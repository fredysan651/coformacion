from rest_framework import viewsets, status
from rest_framework.decorators import api_view, action
from rest_framework.response import Response
from rest_framework import serializers
from .models import Coformacion, Estudiantes, Empresas, Roles, Permisos, RolesPermisos, TiposDocumento, Facultades, Programas, MateriasNucleo, ObjetivosAprendizaje, Promociones, NivelesIngles, EstadosCartera, SectoresEconomicos, TamanosEmpresa, TiposContacto, ContactosEmpresa, OfertasEmpresas, EstadoProceso, ProcesoCoformacion, DocumentosProceso, TiposActividad, CalendarioActividades, PlantillasCorreo, HistorialComunicaciones
from .serializers import OfertasEmpresasSerializer
from .serializers import *
import os

class RolesViewSet(viewsets.ModelViewSet):
    queryset = Roles.objects.all()
    serializer_class = RolesSerializer


class PermisosViewSet(viewsets.ModelViewSet):
    queryset = Permisos.objects.all()
    serializer_class = PermisosSerializer


class RolesPermisosViewSet(viewsets.ModelViewSet):
    queryset = RolesPermisos.objects.all()
    serializer_class = RolesPermisosSerializer

class TiposDocumentoViewSet(viewsets.ModelViewSet):
    queryset = TiposDocumento.objects.all()
    serializer_class = TiposDocumentoSerializer

class FacultadesViewSet(viewsets.ModelViewSet):
    queryset = Facultades.objects.all()
    serializer_class = FacultadesSerializer


class ProgramasViewSet(viewsets.ModelViewSet):
    queryset = Programas.objects.all()
    serializer_class = ProgramasSerializer


class MateriasNucleoViewSet(viewsets.ModelViewSet):
    queryset = MateriasNucleo.objects.all()
    serializer_class = MateriasNucleoSerializer


class ObjetivosAprendizajeViewSet(viewsets.ModelViewSet):
    queryset = ObjetivosAprendizaje.objects.all()
    serializer_class = ObjetivosAprendizajeSerializer


class PromocionesViewSet(viewsets.ModelViewSet):
    queryset = Promociones.objects.all()
    serializer_class = PromocionesSerializer


class NivelesInglesViewSet(viewsets.ModelViewSet):
    queryset = NivelesIngles.objects.all()
    serializer_class = NivelesInglesSerializer


class EstadosCarteraViewSet(viewsets.ModelViewSet):
    queryset = EstadosCartera.objects.all()
    serializer_class = EstadosCarteraSerializer


class EstudiantesViewSet(viewsets.ModelViewSet):
    queryset = Estudiantes.objects.all()
    serializer_class = EstudiantesSerializer

    def update(self, request, *args, **kwargs):
        """
        Actualizar estudiante con manejo detallado de errores
        """
        try:
            print(f"\n=== UPDATE ESTUDIANTE ===")
            print(f"Datos recibidos: {request.data}")
            
            partial = kwargs.pop('partial', False)
            instance = self.get_object()
            serializer = self.get_serializer(instance, data=request.data, partial=partial)
            
            if not serializer.is_valid():
                print(f"Errores de validación: {serializer.errors}")
                return Response(
                    {'errors': serializer.errors, 'detail': 'Validación fallida'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            self.perform_update(serializer)
            print(f"✓ Estudiante actualizado exitosamente")
            return Response(serializer.data)
            
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"\n❌ Error al actualizar estudiante: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al actualizar: {str(e)}', 'trace': error_trace},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    @action(detail=True, methods=['post'], url_path='upload-foto')
    def upload_foto(self, request, pk=None):
        """
        Endpoint para subir la foto de un estudiante
        """
        try:
            estudiante = self.get_object()
            
            # Validar que se envió un archivo
            if 'foto' not in request.FILES:
                return Response(
                    {'error': 'No se proporcionó ningún archivo de imagen'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            archivo_foto = request.FILES['foto']
            
            # Validar extensión del archivo
            extensiones_permitidas = ['jpg', 'jpeg', 'png', 'gif', 'webp']
            nombre_archivo = archivo_foto.name.lower()
            extension = nombre_archivo.split('.')[-1] if '.' in nombre_archivo else ''
            
            if extension not in extensiones_permitidas:
                return Response(
                    {'error': f'Formato no permitido. Use: {", ".join(extensiones_permitidas)}'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Validar tamaño (máximo 5MB)
            if archivo_foto.size > 5 * 1024 * 1024:
                return Response(
                    {'error': 'El archivo no debe exceder 5MB'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Eliminar foto anterior si existe
            if estudiante.foto:
                estudiante.foto.delete()
            
            # Guardar nueva foto
            estudiante.foto = archivo_foto
            estudiante.save()
            
            # Retornar URL de la foto
            serializer = self.get_serializer(estudiante)
            return Response(
                {
                    'success': True,
                    'message': 'Foto actualizada correctamente',
                    'foto_url': estudiante.foto.url if estudiante.foto else None,
                    'estudiante': serializer.data
                },
                status=status.HTTP_200_OK
            )
            
        except Exception as e:
            return Response(
                {'error': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )



class EstudiantesEpsViewSet(viewsets.ModelViewSet):
    queryset = EstudiantesEps.objects.all()
    serializer_class = EstudiantesEpsSerializer

    def create(self, request, *args, **kwargs):
        """
        Crear una nueva EPS validando que no exista duplicado por nombre
        """
        try:
            nombre = request.data.get('nombre', '').strip()
            
            if not nombre:
                return Response(
                    {'error': 'El nombre de la EPS es obligatorio'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Verificar si ya existe una EPS con ese nombre (ignorando mayúsculas/minúsculas)
            eps_existente = EstudiantesEps.objects.filter(nombre__iexact=nombre).first()
            
            if eps_existente:
                return Response(
                    {'error': f'Ya existe una EPS con el nombre "{nombre}"', 'eps_id': eps_existente.eps_id},
                    status=status.HTTP_409_CONFLICT
                )
            
            return super().create(request, *args, **kwargs)
            
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error al crear EPS: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al crear la EPS: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class SectoresEconomicosViewSet(viewsets.ModelViewSet):
    queryset = SectoresEconomicos.objects.all()
    serializer_class = SectoresEconomicosSerializer


class TamanosEmpresaViewSet(viewsets.ModelViewSet):
    queryset = TamanosEmpresa.objects.all()
    serializer_class = TamanosEmpresaSerializer


class EmpresasViewSet(viewsets.ModelViewSet):
    queryset = Empresas.objects.all()
    serializer_class = EmpresasSerializer

    def list(self, request, *args, **kwargs):
        try:
            return super().list(request, *args, **kwargs)
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error en EmpresasViewSet.list: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al obtener empresas: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def retrieve(self, request, *args, **kwargs):
        try:
            return super().retrieve(request, *args, **kwargs)
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error en EmpresasViewSet.retrieve: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al obtener la empresa: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class TiposContactoViewSet(viewsets.ModelViewSet):
    queryset = TiposContacto.objects.all()
    serializer_class = TiposContactoSerializer


class ContactosEmpresaViewSet(viewsets.ModelViewSet):
    queryset = ContactosEmpresa.objects.all()
    serializer_class = ContactosEmpresaSerializer

    def list(self, request, *args, **kwargs):
        try:
            return super().list(request, *args, **kwargs)
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error en ContactosEmpresaViewSet.list: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al obtener contactos de empresa: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class OfertasEmpresasViewSet(viewsets.ModelViewSet):
    queryset = OfertasEmpresas.objects.all()
    serializer_class = OfertasEmpresasSerializer

    def list(self, request, *args, **kwargs):
        try:
            return super().list(request, *args, **kwargs)
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error en OfertasEmpresasViewSet.list: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al obtener ofertas: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def create(self, request, *args, **kwargs):
        """
        Crear una nueva oferta. El serializer maneja toda la lógica de mapeo y validación.
        """
        try:
            # request.data en DRF ya es un dict procesado, pero asegurémonos
            # Convertir QueryDict a dict si es necesario
            if hasattr(request.data, 'dict'):
                # Es un QueryDict, convertir a dict
                data = request.data.dict()
            elif hasattr(request.data, 'copy'):
                data = request.data.copy()
            elif isinstance(request.data, dict):
                data = dict(request.data)
            else:
                data = {}

            # Asegurar que los valores de lista se conviertan a valores simples
            # (QueryDict puede devolver listas para claves duplicadas)
            for key, value in data.items():
                if isinstance(value, list) and len(value) == 1:
                    data[key] = value[0]
                elif isinstance(value, list) and len(value) == 0:
                    data[key] = None

            print(f"Datos recibidos del frontend: {data}")
            print(f"Tipo de datos: {type(data)}")
            print(f"Claves en data: {list(data.keys()) if isinstance(data, dict) else 'No es dict'}")
            print(f"Valor de 'empresa' en data: {data.get('empresa')}, tipo: {type(data.get('empresa'))}")
            print(f"Valor de 'empresa_id' en data: {data.get('empresa_id')}, tipo: {type(data.get('empresa_id'))}")

            # Validar que empresa esté presente - intentar múltiples formas
            empresa_value = None

            # Intentar obtener empresa de diferentes campos
            if 'empresa' in data and data.get('empresa'):
                empresa_value = data.get('empresa')
            elif 'empresa_id' in data and data.get('empresa_id'):
                empresa_value = data.get('empresa_id')
                data['empresa'] = empresa_value
            elif 'empresa' in data:
                # Puede ser 0, None, o string vacío
                empresa_value = data.get('empresa')

            # Convertir a entero si es string
            if empresa_value is not None:
                try:
                    if isinstance(empresa_value, str):
                        empresa_value = int(empresa_value) if empresa_value.strip() else None
                    elif isinstance(empresa_value, (int, float)):
                        empresa_value = int(empresa_value)
                except (ValueError, TypeError):
                    empresa_value = None

            if not empresa_value or empresa_value == 0:
                print(f"ERROR: empresa no encontrado. Datos recibidos: {data}")
                return Response(
                    {
                        'error': 'El campo empresa es requerido',
                        'detalle': 'No se recibió el ID de la empresa. Asegúrate de estar autenticado como empresa.'
                    },
                    status=status.HTTP_400_BAD_REQUEST
                )

            # Asegurar que empresa esté en data como entero
            empresa_id_final = int(empresa_value)
            data['empresa'] = empresa_id_final
            # También asegurar empresa_id por compatibilidad
            data['empresa_id'] = empresa_id_final

            # Verificar que la empresa exista antes de pasar al serializer
            try:
                from .models import Empresas
                empresa_obj = Empresas.objects.get(pk=empresa_id_final)
                print(f"✓ Empresa identificada y verificada: {empresa_id_final} ({empresa_obj.nombre_comercial or empresa_obj.razon_social})")
            except Empresas.DoesNotExist:
                return Response(
                    {
                        'error': f'La empresa con ID {empresa_id_final} no existe en la base de datos.',
                        'detalle': 'Verifica que el ID de empresa sea correcto.'
                    },
                    status=status.HTTP_400_BAD_REQUEST
                )

            print(f"Datos finales antes del serializer: {data}")
            print(f"Claves en data: {list(data.keys())}")
            print(f"Valor de empresa: {data.get('empresa')}, tipo: {type(data.get('empresa'))}")

            # El serializer manejará todo el mapeo y validación
            serializer = self.get_serializer(data=data)
            print(f"Serializer creado, validando datos...")
            serializer.is_valid(raise_exception=True)
            print(f"✓ Validación del serializer exitosa")
            self.perform_create(serializer)
            headers = self.get_success_headers(serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED, headers=headers)
        except serializers.ValidationError as e:
            print(f"Error de validación: {e}")
            return Response(
                {'error': f'Error de validación: {str(e.detail)}'},
                status=status.HTTP_400_BAD_REQUEST
            )
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error en OfertasEmpresasViewSet.create: {e}")
            print(error_trace)
            print(f"Tipo de error: {type(e).__name__}")
            error_message = str(e)
            if hasattr(e, 'detail'):
                error_message = str(e.detail)
            elif hasattr(e, 'args') and e.args:
                error_message = str(e.args[0])
            # Incluir más detalles del error para debugging
            error_response = {
                'error': f'Error al crear la oferta: {error_message}',
                'error_type': type(e).__name__
            }
            return Response(
                error_response,
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class EstadoProcesoViewSet(viewsets.ModelViewSet):
    queryset = EstadoProceso.objects.all()
    serializer_class = EstadoProcesoSerializer


class ProcesoCoformacionViewSet(viewsets.ModelViewSet):
    serializer_class = ProcesoCoformacionSerializer
    
    def get_queryset(self):
        """
        Filtra procesos por estudiante_id si viene en query params.
        Esto asegura que cada estudiante solo vea sus propios procesos.
        """
        queryset = ProcesoCoformacion.objects.all()
        
        # Filtrar por estudiante_id si viene en los query params
        estudiante_id = self.request.query_params.get('estudiante_id')
        if estudiante_id:
            try:
                estudiante_id = int(estudiante_id)
                queryset = queryset.filter(estudiante_id=estudiante_id)
            except (ValueError, TypeError):
                pass  # Si no es un número válido, ignorar el filtro
        
        return queryset


class DocumentosProcesoViewSet(viewsets.ModelViewSet):
    queryset = DocumentosProceso.objects.all()
    serializer_class = DocumentosProcesoSerializer
    
    def get_queryset(self):
        """
        Filtrar documentos por:
        1. Query param: proceso_id (obligatorio en getByProcesoId)
        2. Query param: estudiante_id (si viene, solo documetos de ese estudiante)
        3. Header: X-Student-Id (respaldo del interceptor)
        
        - Estudiantes solo ven sus propios documentos
        - Administrativos ven todos
        """
        queryset = DocumentosProceso.objects.all()
        
        print(f"\n📋 GET_QUERYSET DEBUG:")
        print(f"  Query params: {dict(self.request.query_params)}")
        print(f"  Headers: X-Student-Id={self.request.headers.get('X-Student-Id')}")
        
        # Aplicar filtro de proceso_id (query param)
        proceso_id = self.request.query_params.get('proceso_id')
        if proceso_id:
            try:
                proceso_id = int(proceso_id)
                queryset = queryset.filter(proceso_id=proceso_id)
                print(f"  ✅ Filtered by proceso_id={proceso_id}")
            except (ValueError, TypeError):
                pass
        
        # Aplicar filtro de estudiante_id (PRIORIDAD: query param > header)
        student_id = self.request.query_params.get('estudiante_id') or self.request.headers.get('X-Student-Id')
        
        if student_id:
            try:
                student_id = int(student_id)
                queryset = queryset.filter(proceso__estudiante_id=student_id)
                print(f"  ✅ Filtered by proceso.estudiante_id={student_id}")
            except (ValueError, TypeError) as e:
                print(f"  ❌ Error parsing student_id: {e}")
        
        final_count = queryset.count()
        print(f"  📊 Final documentos: {final_count}\n")
        
        return queryset
    
    @action(detail=False, methods=['post'], url_path='upload', url_name='documento-upload')
    def upload(self, request):
        """
        Endpoint para subir documentos con multipart/form-data
        Parámetros esperados:
        - file: archivo (multipart)
        - proceso_id: ID del proceso (int)
        - tipo_doc_id: ID del tipo de documento (int)
        """
        try:
            # Obtener el archivo
            file = request.FILES.get('file')
            if not file:
                return Response(
                    {'error': 'No se proporcionó ningún archivo'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Obtener proceso_id y tipo_doc_id
            proceso_id = request.POST.get('proceso_id')
            tipo_doc_id = request.POST.get('tipo_doc_id')
            
            if not proceso_id or not tipo_doc_id:
                return Response(
                    {'error': 'Faltan parámetros: proceso_id o tipo_doc_id'},
                    status=status.HTTP_400_BAD_REQUEST
                )
            
            # Validar que el proceso existe
            from .models import ProcesoCoformacion, TiposDocumento
            try:
                proceso = ProcesoCoformacion.objects.get(proceso_id=int(proceso_id))
            except ProcesoCoformacion.DoesNotExist:
                return Response(
                    {'error': f'Proceso {proceso_id} no encontrado'},
                    status=status.HTTP_404_NOT_FOUND
                )
            
            # Validar que el tipo de documento existe
            try:
                tipo_doc = TiposDocumento.objects.get(tipo_doc_id=int(tipo_doc_id))
            except TiposDocumento.DoesNotExist:
                return Response(
                    {'error': f'Tipo de documento {tipo_doc_id} no encontrado'},
                    status=status.HTTP_404_NOT_FOUND
                )
            
            # Crear directorio si no existe
            from django.conf import settings
            import os
            media_documentos = os.path.join(settings.MEDIA_ROOT, 'documentos')
            os.makedirs(media_documentos, exist_ok=True)
            
            # Generar nombre único para el archivo
            import time
            timestamp = int(time.time() * 1000)
            original_name = os.path.splitext(file.name)
            file_name = f"doc_{proceso_id}_{timestamp}{original_name[1]}"
            file_path = os.path.join(media_documentos, file_name)
            
            # Guardar el archivo
            with open(file_path, 'wb') as f:
                for chunk in file.chunks():
                    f.write(chunk)
            
            # Crear registro en la base de datos
            documento = DocumentosProceso.objects.create(
                proceso=proceso,
                tipo_doc=tipo_doc,
                url_documento=f'documentos/{file_name}',  # ruta relativa
                fecha_envio=__import__('django.utils.timezone', fromlist=['now']).now(),
                estado='Pendiente'
            )
            
            # Retornar el documento creado
            serializer = self.get_serializer(documento)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
            
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"❌ Error al cargar documento: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al cargar documento: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
    
    @action(detail=True, methods=['get'], url_path='download', url_name='documento-download')
    def download(self, request, pk=None):
        """
        Endpoint para descargar un documento
        """
        try:
            documento = self.get_object()
            
            from django.conf import settings
            import os
            
            # Construir la ruta del archivo
            file_path = os.path.join(settings.MEDIA_ROOT, documento.url_documento)
            
            # Validar que el archivo existe
            if not os.path.exists(file_path):
                return Response(
                    {'error': 'Archivo no encontrado'},
                    status=status.HTTP_404_NOT_FOUND
                )
            
            # Retornar el archivo
            from django.http import FileResponse
            response = FileResponse(open(file_path, 'rb'))
            
            # Obtener el nombre del archivo original
            file_name = os.path.basename(file_path)
            response['Content-Disposition'] = f'attachment; filename="{file_name}"'
            
            return response
            
        except DocumentosProceso.DoesNotExist:
            return Response(
                {'error': 'Documento no encontrado'},
                status=status.HTTP_404_NOT_FOUND
            )
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"❌ Error al descargar documento: {e}")
            print(error_trace)
            return Response(
                {'error': f'Error al descargar documento: {str(e)}'},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class TiposActividadViewSet(viewsets.ModelViewSet):
    queryset = TiposActividad.objects.all()
    serializer_class = TiposActividadSerializer


class CalendarioActividadesViewSet(viewsets.ModelViewSet):
    queryset = CalendarioActividades.objects.all()
    serializer_class = CalendarioActividadesSerializer


class PlantillasCorreoViewSet(viewsets.ModelViewSet):
    queryset = PlantillasCorreo.objects.all()
    serializer_class = PlantillasCorreoSerializer


class HistorialComunicacionesViewSet(viewsets.ModelViewSet):
    queryset = HistorialComunicaciones.objects.all()
    serializer_class = HistorialComunicacionesSerializer


class CoformacionViewSet(viewsets.ModelViewSet):
    queryset = Coformacion.objects.all()
    serializer_class = CoformacionSerializer

@api_view(['POST'])
def login_universal(request):
    """
    Endpoint universal para autenticar estudiantes, empresas y usuarios de coformación
    """
    # Normalizar entradas
    nombre_completo = request.data.get('nombre_completo')
    numero_documento = request.data.get('numero_documento')
    tipo_usuario = request.data.get('tipo_usuario')  # Puede venir o no

    if isinstance(nombre_completo, str):
        # Remover espacios extras (al inicio, final y múltiples espacios en el medio)
        nombre_completo = ' '.join(nombre_completo.split())
    if isinstance(numero_documento, str):
        numero_documento = numero_documento.strip()

    if not nombre_completo or not numero_documento:
        return Response(
            {'error': 'Se requieren nombre completo y número de documento'},
            status=status.HTTP_400_BAD_REQUEST
        )

    try:
        # Si se especifica tipo_usuario, usar la lógica anterior (compatibilidad)
        if tipo_usuario == 'coformacion':
            usuario = Coformacion.objects.get(
                nombre_completo__icontains=nombre_completo,
                identificacion=numero_documento
            )
            serializer = CoformacionSerializer(usuario)
            redirect_to = '/coformacion'
            tipo_detectado = 'coformacion'
        elif tipo_usuario == 'estudiante':
            from django.db.models import Q, Value, CharField
            from django.db.models.functions import Concat
            
            # Dividir el nombre en palabras para búsqueda flexible
            palabras = nombre_completo.split()
            
            # Crear filtro Q que busque cualquier combinación de palabras
            q_filter = Q()
            for palabra in palabras:
                q_filter |= Q(nombres__icontains=palabra) | Q(apellidos__icontains=palabra)
            
            # Buscar estudiante
            usuario = Estudiantes.objects.filter(
                q_filter,
                numero_documento=numero_documento
            ).first()
            
            if not usuario:
                raise Estudiantes.DoesNotExist
            serializer = EstudiantesSerializer(usuario)
            redirect_to = '/perfil-estudiante'
            tipo_detectado = 'estudiante'
        elif tipo_usuario == 'empresa':
            # Intentar por nombre_comercial o razon_social
            from django.db.models import Q
            usuario = Empresas.objects.get(
                Q(nombre_comercial__icontains=nombre_completo) | Q(razon_social__icontains=nombre_completo),
                nit_empresa=numero_documento
            )
            serializer = EmpresasSerializer(usuario)
            redirect_to = '/home-empresa'
            tipo_detectado = 'empresa'
        else:
            # Lógica universal: probar coformacion, luego estudiante, luego empresa
            try:
                usuario = Coformacion.objects.get(
                    nombre_completo__icontains=nombre_completo,
                    identificacion=numero_documento
                )
                serializer = CoformacionSerializer(usuario)
                redirect_to = '/coformacion'
                tipo_detectado = 'coformacion'
            except Coformacion.DoesNotExist:
                try:
                    from django.db.models import Q
                    
                    # Dividir el nombre en palabras para búsqueda flexible
                    palabras = nombre_completo.split()
                    
                    # Crear filtro Q que busque cualquier combinación de palabras
                    q_filter = Q()
                    for palabra in palabras:
                        q_filter |= Q(nombres__icontains=palabra) | Q(apellidos__icontains=palabra)
                    
                    # Buscar estudiante por nombres y apellidos
                    usuario = Estudiantes.objects.filter(
                        q_filter,
                        numero_documento=numero_documento
                    ).first()
                    
                    if not usuario:
                        raise Estudiantes.DoesNotExist
                        
                    serializer = EstudiantesSerializer(usuario)
                    redirect_to = '/perfil-estudiante'
                    tipo_detectado = 'estudiante'
                except Estudiantes.DoesNotExist:
                    try:
                        from django.db.models import Q
                        usuario = Empresas.objects.get(
                            Q(nombre_comercial__icontains=nombre_completo) | Q(razon_social__icontains=nombre_completo),
                            nit_empresa=numero_documento
                        )
                        serializer = EmpresasSerializer(usuario)
                        redirect_to = '/home-empresa'
                        tipo_detectado = 'empresa'
                    except Empresas.DoesNotExist:
                        # Información mínima para diagnóstico en desarrollo (sin exponer datos sensibles)
                        return Response(
                            {
                                'error': 'Credenciales incorrectas. Verifique sus datos.',
                                'detalle': {
                                    'nombre_completo': nombre_completo,
                                    'numero_documento': numero_documento
                                }
                            },
                            status=status.HTTP_401_UNAUTHORIZED
                        )

        return Response({
            'success': True,
            'message': f'Login exitoso como {tipo_detectado}',
            'data': serializer.data,
            'tipo_usuario': tipo_detectado,
            'redirect_to': redirect_to
        }, status=status.HTTP_200_OK)

    except Exception as e:
        return Response(
            {'error': f'Error interno del servidor: {str(e)}'},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

# Mantener el endpoint específico de estudiantes por compatibilidad
@api_view(['POST'])
def login_estudiante(request):
    """
    Endpoint específico para autenticar estudiantes (mantenido por compatibilidad)
    """
    request.data['tipo_usuario'] = 'estudiante'
    return login_universal(request)

@api_view(['POST'])
def recomendar_ofertas(request):
    # Importación lazy para evitar errores de grpc al iniciar el servidor
    try:
        import google.generativeai as genai
        genai.configure(api_key=os.getenv("AIzaSyDlrQj_C8iSkOwdRli8aJxQGH7I898TuXM"))
    except ImportError:
        return Response({"error": "Google Generative AI no está disponible"}, status=status.HTTP_503_SERVICE_UNAVAILABLE)
    except Exception as e:
        return Response({"error": f"Error al configurar Generative AI: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    estudiante = request.data.get("estudiante")
    ofertas = request.data.get("ofertas")

    if not estudiante or not ofertas:
        return Response({"error": "Faltan datos"}, status=status.HTTP_400_BAD_REQUEST)

    prompt = f"""
    Eres un sistema de recomendación para un estudiante.
    El estudiante tiene este perfil: {estudiante}
    Estas son las ofertas disponibles: {ofertas}
    Devuélveme un JSON con las 3 ofertas más relevantes explicando brevemente por qué.
    """

    try:
        model = genai.GenerativeModel("gemini-1.5-flash")
        response = model.generate_content(prompt)
        return Response({"recomendaciones": response.text})
    except Exception as e:
        return Response({"error": str(e)}, status=500)

@api_view(['GET'])
def recomendaciones_por_estudiante(request, estudiante_id):
    """
    Obtiene recomendaciones de ofertas para todos los estudiantes del mismo programa
    que el estudiante especificado, mostrando qué estudiantes son compatibles con cada oferta.
    """
    try:
        # Obtener el estudiante de referencia para conocer su programa
        estudiante_referencia = Estudiantes.objects.get(pk=estudiante_id)

        # Buscar todas las ofertas que coincidan con el programa del estudiante de referencia
        ofertas = OfertasEmpresas.objects.filter(programa_id=estudiante_referencia.programa_id)

        # Buscar todos los estudiantes del mismo programa que están disponibles
        estudiantes_programa = Estudiantes.objects.filter(
            programa_id=estudiante_referencia.programa_id,
            estado='Activo'  # Solo estudiantes activos
        )

        # Crear lista de recomendaciones
        recomendaciones = []

        for oferta in ofertas:
            # Serializar la oferta
            serializer = OfertasEmpresasSerializer(oferta)
            oferta_data = serializer.data

            # Encontrar estudiantes compatibles para esta oferta
            # (por ahora todos los del mismo programa, pero aquí se puede agregar más lógica de matching)
            estudiantes_compatibles = estudiantes_programa

            # Si hay estudiantes compatibles, crear una recomendación por cada uno
            if estudiantes_compatibles.exists():
                # Para mostrar variedad, podemos rotar entre estudiantes o usar algún criterio
                # Por ahora, asignaremos el primer estudiante disponible pero rotando
                index = oferta.idOferta % estudiantes_compatibles.count()
                estudiante_asignado = estudiantes_compatibles[index]

                nombre_completo = f"{estudiante_asignado.nombres} {estudiante_asignado.apellidos}".strip()
                oferta_data["estudiante"] = nombre_completo
                oferta_data["estudiante_id"] = estudiante_asignado.estudiante_id
                recomendaciones.append(oferta_data)
            else:
                # Si no hay estudiantes compatibles, mostrar sin asignar
                oferta_data["estudiante"] = "Sin asignar"
                oferta_data["estudiante_id"] = None
                recomendaciones.append(oferta_data)

        return Response(recomendaciones)

    except Estudiantes.DoesNotExist:
        return Response({'error': 'Estudiante no encontrado'}, status=404)

@api_view(['GET'])
def recomendaciones_completas(request):
    """
    Obtiene todas las ofertas disponibles y muestra estudiantes compatibles para cada una.
    Este endpoint es útil para ver el panorama completo de ofertas y estudiantes.
    """
    try:
        # Obtener todas las ofertas activas
        ofertas = OfertasEmpresas.objects.all()

        # Obtener todos los estudiantes activos
        estudiantes_activos = Estudiantes.objects.filter(estado='Activo')

        recomendaciones_completas = []

        for oferta in ofertas:
            # Serializar la oferta
            serializer = OfertasEmpresasSerializer(oferta)
            oferta_data = serializer.data

            # Encontrar estudiantes compatibles para esta oferta
            estudiantes_compatibles = estudiantes_activos.filter(
                programa_id=oferta.programa_id
            )

            if estudiantes_compatibles.exists():
                # Crear una recomendación para cada estudiante compatible
                for i, estudiante in enumerate(estudiantes_compatibles):
                    oferta_recomendacion = oferta_data.copy()
                    nombre_completo = f"{estudiante.nombres} {estudiante.apellidos}".strip()
                    oferta_recomendacion["estudiante"] = nombre_completo
                    oferta_recomendacion["estudiante_id"] = estudiante.estudiante_id
                    oferta_recomendacion["es_principal"] = i == 0  # Marcar el primer estudiante como principal
                    recomendaciones_completas.append(oferta_recomendacion)
            else:
                # Si no hay estudiantes compatibles, mostrar sin asignar
                oferta_data["estudiante"] = "Sin estudiantes compatibles"
                oferta_data["estudiante_id"] = None
                oferta_data["es_principal"] = True
                recomendaciones_completas.append(oferta_data)

        return Response({
            'total_ofertas': ofertas.count(),
            'total_estudiantes_activos': estudiantes_activos.count(),
            'recomendaciones': recomendaciones_completas
        })

    except Exception as e:
        return Response({'error': f'Error interno: {str(e)}'}, status=500)
