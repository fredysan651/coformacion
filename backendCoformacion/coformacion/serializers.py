from rest_framework import serializers
from .models import *

class RolesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Roles
        fields = '__all__'


class PermisosSerializer(serializers.ModelSerializer):
    class Meta:
        model = Permisos
        fields = '__all__'


class RolesPermisosSerializer(serializers.ModelSerializer):
    class Meta:
        model = RolesPermisos
        fields = '__all__'

class TiposDocumentoSerializer(serializers.ModelSerializer):
    class Meta:
        model = TiposDocumento
        fields = '__all__'


class FacultadesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Facultades
        fields = '__all__'


class ProgramasSerializer(serializers.ModelSerializer):
    class Meta:
        model = Programas
        fields = '__all__'


class MateriasNucleoSerializer(serializers.ModelSerializer):
    class Meta:
        model = MateriasNucleo
        fields = '__all__'


class ObjetivosAprendizajeSerializer(serializers.ModelSerializer):
    class Meta:
        model = ObjetivosAprendizaje
        fields = '__all__'

class PromocionesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Promociones
        fields = '__all__'


class NivelesInglesSerializer(serializers.ModelSerializer):
    class Meta:
        model = NivelesIngles
        fields = '__all__'


class EstadosCarteraSerializer(serializers.ModelSerializer):
    class Meta:
        model = EstadosCartera
        fields = '__all__'


class ContactosDeEmergenciaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContactosDeEmergencia
        fields = '__all__'
        extra_kwargs = {'estudiante': {'required': False}}


class EstudiantesEpsSerializer(serializers.ModelSerializer):
    class Meta:
        model = EstudiantesEps
        fields = '__all__'


class EstudiantesSerializer(serializers.ModelSerializer):
    nombre_completo = serializers.CharField(write_only=False, required=False, allow_blank=True)
    eps_info = EstudiantesEpsSerializer(source='eps_id', read_only=True)
    
    class Meta:
        model = Estudiantes
        fields = '__all__'
        extra_kwargs = {
            'fecha_creacion': {'required': False, 'read_only': True},
            'fecha_actualizacion': {'required': False, 'read_only': True},
            'codigo_estudiante': {'required': False},
            'tipo_documento': {'required': False},
            'numero_documento': {'required': False},
            'programa_id': {'required': False},
            'jornada': {'required': False},
            'semestre': {'required': False},
            'fecha_nacimiento': {'required': False},
            'genero': {'required': False},
            'celular': {'required': False},
            'email_institucional': {'required': False},
            'apellidos': {'required': False},
            'nombres': {'required': False},
            'fecha_ingreso': {'required': False},
            'email_personal': {'required': False},
            'direccion': {'required': False},
            'ciudad': {'required': False},
            'telefono': {'required': False},
            'foto': {'required': False},
            'promedio_acumulado': {'required': False},
            'estado': {'required': False},
            'nivel_ingles_id': {'required': False},
            'promocion_id': {'required': False},
            'estado_cartera_id': {'required': False},
            'empresa_id': {'required': False},
            'eps_id': {'required': False},
        }
    
    def get_nombre_completo(self, obj):
        """Combina nombres y apellidos para mostrar el nombre completo"""
        nombres = obj.nombres or ''
        apellidos = obj.apellidos or ''
        return f"{apellidos} {nombres}".strip() if (nombres or apellidos) else 'No registrado'
    
    def to_representation(self, instance):
        """Mostrar nombre_completo calculado en la respuesta"""
        data = super().to_representation(instance)
        data['nombre_completo'] = self.get_nombre_completo(instance)
        return data
    
    def update(self, instance, validated_data):
        """
        Actualizar estudiante, procesando nombre_completo si se envía
        """
        print(f"\n[UPDATE] Datos validados: {validated_data}")
        
        # Excluir campos de timestamp si no vienen en los datos
        validated_data.pop('fecha_creacion', None)
        validated_data.pop('fecha_actualizacion', None)
        
        # Procesar nombre_completo si viene en los datos
        nombre_completo = validated_data.pop('nombre_completo', None)
        if nombre_completo:
            print(f"[UPDATE] Procesando nombre_completo: {nombre_completo}")
            # Dividir nombre_completo en apellidos y nombres
            partes = nombre_completo.strip().split(' ', 1)
            if len(partes) == 2:
                validated_data['apellidos'] = partes[0]
                validated_data['nombres'] = partes[1]
            elif len(partes) == 1:
                validated_data['nombres'] = partes[0]
        
        # Actualizar la fecha de actualización automáticamente
        from django.utils import timezone
        instance.fecha_actualizacion = timezone.now()
        
        # Actualizar solo los campos que vinieron en validated_data
        for attr, value in validated_data.items():
            if hasattr(instance, attr):
                setattr(instance, attr, value)
                print(f"[UPDATE] {attr} = {value}")
        
        instance.save()
        print(f"[UPDATE] Guardado exitoso")
        return instance


class SectoresEconomicosSerializer(serializers.ModelSerializer):
    class Meta:
        model = SectoresEconomicos
        fields = '__all__'


class TamanosEmpresaSerializer(serializers.ModelSerializer):
    class Meta:
        model = TamanosEmpresa
        fields = '__all__'


class EmpresasSerializer(serializers.ModelSerializer):
    nombre_persona_contacto_empresa = serializers.CharField(required=False, allow_blank=True)
    cargo_persona_contacto_empresa = serializers.CharField(required=False, allow_blank=True)
    numero_persona_contacto_empresa = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    email_empresa = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    ciudad_duplicada = serializers.CharField(required=False, allow_blank=True)
    
    class Meta:
        model = Empresas
        fields = '__all__'
        depth = 0  # Solo devolver IDs de ForeignKeys, no objetos anidados
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        # Remover logo_url de los fields si existe (ya que está comentado en el modelo)
        if 'logo_url' in self.fields:
            self.fields.pop('logo_url')
    
    def to_internal_value(self, data):
        """
        Interceptar los datos antes de la validación para debugging
        """
        print(f"EmpresasSerializer - Datos recibidos: {data}")
        try:
            result = super().to_internal_value(data)
            print(f"EmpresasSerializer - Datos validados: {result}")
            return result
        except Exception as e:
            print(f"EmpresasSerializer - Error en validación: {e}")
            raise
    
    def create(self, validated_data):
        """
        Crear una empresa mapeando correctamente los campos a los nombres de columna de la BD
        """
        try:
            # Limpiar valores vacíos que podrían causar problemas
            for key, value in list(validated_data.items()):
                if isinstance(value, str) and value.strip() == '':
                    # Si es un campo opcional, establecerlo como None
                    try:
                        field = self.Meta.model._meta.get_field(key)
                        if field.null or field.blank:
                            validated_data[key] = None if field.null else ''
                    except:
                        pass
            
            # Asegurar que actividad_economica no esté vacío
            if 'actividad_economica' in validated_data and (not validated_data['actividad_economica'] or validated_data['actividad_economica'].strip() == ''):
                validated_data['actividad_economica'] = 'No especificada'
            
            # Asignar el valor de ciudad también a ciudad_duplicada (columna 'ciudad' en BD)
            if 'ciudad' in validated_data and validated_data['ciudad']:
                validated_data['ciudad_duplicada'] = validated_data['ciudad']
            elif 'ciudad_duplicada' not in validated_data:
                validated_data['ciudad_duplicada'] = validated_data.get('ciudad', 'No especificada')
            
            # Asignar valores por defecto a campos requeridos de contacto si no se proporcionan
            if 'nombre_persona_contacto_empresa' not in validated_data or not validated_data.get('nombre_persona_contacto_empresa'):
                validated_data['nombre_persona_contacto_empresa'] = 'No especificado'
            
            if 'cargo_persona_contacto_empresa' not in validated_data or not validated_data.get('cargo_persona_contacto_empresa'):
                validated_data['cargo_persona_contacto_empresa'] = 'No especificado'
            
            # Asegurar que numero_persona_contacto_empresa sea None si está vacío (es opcional)
            if 'numero_persona_contacto_empresa' in validated_data and (not validated_data['numero_persona_contacto_empresa'] or validated_data['numero_persona_contacto_empresa'].strip() == ''):
                validated_data['numero_persona_contacto_empresa'] = None
            
            # Asegurar que email_empresa sea None si está vacío (es opcional)
            if 'email_empresa' in validated_data and (not validated_data['email_empresa'] or validated_data['email_empresa'].strip() == ''):
                validated_data['email_empresa'] = None
            
            empresa = Empresas.objects.create(**validated_data)
            return empresa
        except Exception as e:
            import traceback
            error_details = traceback.format_exc()
            print(f"Error al crear empresa: {e}")
            print(f"Error completo:\n{error_details}")
            print(f"Datos recibidos: {validated_data}")
            raise serializers.ValidationError({
                'error': f'Error al crear la empresa: {str(e)}',
                'details': str(e)
            })


class TiposContactoSerializer(serializers.ModelSerializer):
    class Meta:
        model = TiposContacto
        fields = '__all__'


class ContactosEmpresaSerializer(serializers.ModelSerializer):
    class Meta:
        model = ContactosEmpresa
        fields = '__all__'


class EstadoProcesoSerializer(serializers.ModelSerializer):
    class Meta:
        model = EstadoProceso
        fields = '__all__'


class ProcesoCoformacionSerializer(serializers.ModelSerializer):
    # Mapear campos con nombres más simples para el frontend
    fecha_inicio = serializers.DateField(source='fecha_inicio_fase_coformacion')
    fecha_fin = serializers.DateField(source='fecha_fin_fase_practica', required=False, allow_null=True)
    
    class Meta:
        model = ProcesoCoformacion
        fields = [
            'proceso_id', 'estudiante', 'empresa', 'estado',
            'fecha_inicio', 'fecha_fin',
            'fecha_ingreso_empresa', 'fecha_finalizacion_empresa',
            'fecha_carta_presentacion', 'horario', 'forma_de_pago',
            'trabaja_sabado', 'salario', 'modalidad_vinculacion',
            'carta_presentacion_enviada', 'carta_presentacion_recibida',
            'modalidad_coformacion', 'observaciones',
            'fecha_creacion', 'fecha_actualizacion'
        ]
    
    def create(self, validated_data):
        # Mapear campos al crear
        fecha_inicio = validated_data.pop('fecha_inicio_fase_coformacion', None)
        fecha_fin = validated_data.pop('fecha_fin_fase_practica', None)
        
        proceso = ProcesoCoformacion.objects.create(
            fecha_inicio_fase_coformacion=fecha_inicio,
            fecha_fin_fase_practica=fecha_fin,
            **validated_data
        )
        return proceso
    
    def update(self, instance, validated_data):
        # Mapear campos al actualizar
        fecha_inicio = validated_data.pop('fecha_inicio_fase_coformacion', None)
        fecha_fin = validated_data.pop('fecha_fin_fase_practica', None)
        
        if fecha_inicio is not None:
            instance.fecha_inicio_fase_coformacion = fecha_inicio
        if fecha_fin is not None:
            instance.fecha_fin_fase_practica = fecha_fin
            
        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        
        instance.save()
        return instance


class DocumentosProcesoSerializer(serializers.ModelSerializer):
    class Meta:
        model = DocumentosProceso
        fields = '__all__'
        extra_kwargs = {
            'fecha_envio': {'required': True},
            'proceso': {'required': True},
            'tipo_doc': {'required': True},
            'url_documento': {'required': True},
        }


class TiposActividadSerializer(serializers.ModelSerializer):
    class Meta:
        model = TiposActividad
        fields = '__all__'


class CalendarioActividadesSerializer(serializers.ModelSerializer):
    class Meta:
        model = CalendarioActividades
        fields = '__all__'


class PlantillasCorreoSerializer(serializers.ModelSerializer):
    class Meta:
        model = PlantillasCorreo
        fields = '__all__'


class HistorialComunicacionesSerializer(serializers.ModelSerializer):
    class Meta:
        model = HistorialComunicaciones
        fields = '__all__'


class CoformacionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Coformacion
        fields = '__all__'


class EmpresaSerializer(serializers.ModelSerializer):
    class Meta:
        model = Empresas
        fields = '__all__'


class EstudianteSerializer(serializers.ModelSerializer):
    empresa = EmpresaSerializer(source='empresa_id', read_only=True)
    eps_info = EstudiantesEpsSerializer(source='eps_id', read_only=True)
    nombre_completo = serializers.CharField(write_only=False, required=False, allow_blank=True)
    
    class Meta:
        model = Estudiantes
        fields = '__all__'
        extra_kwargs = {
            'fecha_creacion': {'required': False, 'read_only': True},
            'fecha_actualizacion': {'required': False, 'read_only': True},
            'codigo_estudiante': {'required': False},
            'tipo_documento': {'required': False},
            'numero_documento': {'required': False},
            'programa_id': {'required': False},
            'jornada': {'required': False},
            'semestre': {'required': False},
            'fecha_nacimiento': {'required': False},
            'genero': {'required': False},
            'celular': {'required': False},
            'email_institucional': {'required': False},
            'apellidos': {'required': False},
            'nombres': {'required': False},
            'fecha_ingreso': {'required': False},
            'email_personal': {'required': False},
            'direccion': {'required': False},
            'ciudad': {'required': False},
            'telefono': {'required': False},
            'foto': {'required': False},
            'promedio_acumulado': {'required': False},
            'estado': {'required': False},
            'nivel_ingles_id': {'required': False},
            'promocion_id': {'required': False},
            'estado_cartera_id': {'required': False},
            'empresa_id': {'required': False},
            'eps_id': {'required': False},
        }
    
    def get_nombre_completo(self, obj):
        """Combina nombres y apellidos para mostrar el nombre completo"""
        nombres = obj.nombres or ''
        apellidos = obj.apellidos or ''
        return f"{apellidos} {nombres}".strip() if (nombres or apellidos) else 'No registrado'
    
    def to_representation(self, instance):
        """Mostrar nombre_completo calculado en la respuesta"""
        data = super().to_representation(instance)
        data['nombre_completo'] = self.get_nombre_completo(instance)
        return data
    
    def update(self, instance, validated_data):
        """Procesar nombre_completo si se envía"""
        validated_data.pop('fecha_creacion', None)
        validated_data.pop('fecha_actualizacion', None)
        
        nombre_completo = validated_data.pop('nombre_completo', None)
        if nombre_completo:
            partes = nombre_completo.strip().split(' ', 1)
            if len(partes) == 2:
                validated_data['apellidos'] = partes[0]
                validated_data['nombres'] = partes[1]
            elif len(partes) == 1:
                validated_data['nombres'] = partes[0]
        
        from django.utils import timezone
        instance.fecha_actualizacion = timezone.now()
        
        for attr, value in validated_data.items():
            if hasattr(instance, attr):
                setattr(instance, attr, value)
        instance.save()
        return instance

class OfertasEmpresasSerializer(serializers.ModelSerializer):
    empresa_nombre = serializers.CharField(source='empresa.nombre_comercial', read_only=True)
    programa_nombre = serializers.CharField(source='programa_id.nombre', read_only=True)
    # Definir empresa explícitamente para aceptar IDs
    # required=True pero lo validamos manualmente para mejor control
    empresa = serializers.PrimaryKeyRelatedField(queryset=Empresas.objects.all(), required=True)
    # Hacer campos opcionales en el serializer (manejaremos defaults en create)
    nacional = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    nombreTutor = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    apoyoEconomico = serializers.DecimalField(max_digits=10, decimal_places=2, required=False, allow_null=True)
    modalidad = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    nombreEmpresa = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    programa_id = serializers.PrimaryKeyRelatedField(queryset=Programas.objects.all(), required=False, allow_null=True)
    Ofrece_apoyo = serializers.CharField(required=False, allow_blank=True, allow_null=True)
    brinda_eps = serializers.CharField(required=False, allow_blank=True, allow_null=True)

    class Meta:
        model = OfertasEmpresas
        # Usar fields en lugar de exclude para tener control total
        fields = ['idOferta', 'nacional', 'nombreTutor', 'apoyoEconomico', 
                 'modalidad', 'nombreEmpresa', 'empresa', 'programa_id', 'Ofrece_apoyo',
                 'brinda_eps', 'empresa_nombre', 'programa_nombre']
        extra_fields = ['empresa_nombre', 'programa_nombre']
    
    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        
        # SIEMPRE excluir tipo_oferta y otros campos que no existen en la BD
        campos_a_excluir = ['tipo_oferta', 'apoyo_economico', 'nombre_responsable', 'descripcion', 'fecha_inicio', 'fecha_fin']
        for campo in campos_a_excluir:
            if campo in self.fields:
                self.fields.pop(campo)
                print(f"✓ Campo '{campo}' excluido del serializer")
        
        # Verificar qué campos existen en la base de datos
        try:
            from django.db import connection
            with connection.cursor() as cursor:
                cursor.execute("SHOW COLUMNS FROM ofertasempresas")
                existing_columns = [row[0] for row in cursor.fetchall()]
            
            # Excluir cualquier campo que no exista en la BD
            # IMPORTANTE: 'empresa' es un ForeignKey, la columna en BD es 'empresa_id'
            # No debemos remover 'empresa' porque es el campo del modelo Django
            campos_para_remover = []
            for campo in self.fields.keys():
                # Mantener campos especiales como empresa_nombre, programa_nombre (read_only)
                if campo in ['empresa_nombre', 'programa_nombre']:
                    continue
                # Mantener campos de ForeignKey (empresa, programa_id) aunque no estén en existing_columns
                # porque las columnas en BD son empresa_id y programa_id
                if campo in ['empresa', 'programa_id']:
                    continue
                # Si el campo no existe en la BD y no es un campo especial, excluirlo
                if campo not in existing_columns and campo not in ['idOferta']:
                    campos_para_remover.append(campo)
            
            for campo in campos_para_remover:
                if campo in self.fields:
                    self.fields.pop(campo)
                    print(f"Campo '{campo}' removido del serializer porque no existe en la base de datos")
        except Exception as e:
            # Si hay error al verificar, continuar con todos los campos
            print(f"Advertencia: No se pudo verificar columnas de la base de datos: {e}")

    def to_internal_value(self, data):
        print(f"DATOS RECIBIDOS EN SERIALIZER: {data}")
        
        # Hacer una copia para no modificar los datos originales
        data = data.copy() if hasattr(data, 'copy') else dict(data)
        
        # CRÍTICO: Asegurar que empresa esté presente ANTES de la validación
        # Puede venir como empresa, empresa_id, o ambos
        empresa_value = None
        
        # Prioridad 1: Si viene como 'empresa'
        if 'empresa' in data:
            empresa_value = data.get('empresa')
            # Verificar que no sea None, 0, o string vacío
            if empresa_value is None or empresa_value == 0 or empresa_value == '':
                empresa_value = None
            else:
                # Convertir a entero si es string
                try:
                    if isinstance(empresa_value, str):
                        empresa_value = int(empresa_value.strip()) if empresa_value.strip() else None
                    elif isinstance(empresa_value, (int, float)):
                        empresa_value = int(empresa_value)
                except (ValueError, TypeError):
                    empresa_value = None
        
        # Prioridad 2: Si no está en 'empresa', buscar en 'empresa_id'
        if not empresa_value and 'empresa_id' in data:
            empresa_value = data.get('empresa_id')
            if empresa_value is not None and empresa_value != 0 and empresa_value != '':
                try:
                    if isinstance(empresa_value, str):
                        empresa_value = int(empresa_value.strip()) if empresa_value.strip() else None
                    elif isinstance(empresa_value, (int, float)):
                        empresa_value = int(empresa_value)
                except (ValueError, TypeError):
                    empresa_value = None
        
        # Si encontramos un valor válido, asegurar que esté en 'empresa'
        if empresa_value and empresa_value != 0:
            # Verificar que la empresa exista en la BD
            try:
                from .models import Empresas
                empresa_obj = Empresas.objects.get(pk=empresa_value)
                # PrimaryKeyRelatedField acepta el ID directamente como entero
                data['empresa'] = empresa_value
                print(f"✓ empresa mapeado correctamente: {empresa_value} (empresa existe: {empresa_obj.nombre_comercial or empresa_obj.razon_social})")
            except Empresas.DoesNotExist:
                print(f"❌ ERROR: Empresa con ID {empresa_value} no existe en la base de datos")
                raise serializers.ValidationError({
                    'empresa': f'La empresa con ID {empresa_value} no existe. Verifica el ID de empresa.'
                })
            except Exception as e:
                print(f"❌ ERROR al buscar empresa: {e}")
                raise serializers.ValidationError({
                    'empresa': f'Error al validar la empresa: {str(e)}'
                })
        else:
            # Si no hay valor válido, lanzar error inmediatamente
            print(f"❌ ERROR: empresa no encontrado o inválido en los datos recibidos")
            print(f"Datos recibidos: {data}")
            raise serializers.ValidationError({
                'empresa': 'El campo empresa es requerido. Asegúrate de estar autenticado como empresa y que el ID sea válido.'
            })
        
        # Mapear tipo_oferta a nacional antes de la validación
        # tipo_oferta: 'Nacional' -> nacional: 'Si'
        # tipo_oferta: 'Internacional' -> nacional: 'No'
        if 'tipo_oferta' in data:
            tipo_oferta = data.get('tipo_oferta', 'Nacional')
            if tipo_oferta == 'Nacional':
                data['nacional'] = 'Si'
            elif tipo_oferta == 'Internacional':
                data['nacional'] = 'No'
            else:
                data['nacional'] = 'No'  # Por defecto
            # Remover tipo_oferta ya que no existe en la BD
            del data['tipo_oferta']
        
        # Mapear nombre_responsable a nombreTutor
        if 'nombre_responsable' in data and 'nombreTutor' not in data:
            data['nombreTutor'] = data['nombre_responsable']
            del data['nombre_responsable']
        
        # Mapear apoyo_economico a apoyoEconomico y Ofrece_apoyo
        # apoyo_economico viene como 'Si' o 'No' del frontend
        # apoyoEconomico en la BD es un decimal NOT NULL
        # Ofrece_apoyo guarda 'Si' o 'No'
        if 'apoyo_economico' in data:
            apoyo_economico_value = data.get('apoyo_economico', 'No')
            # Guardar Si/No en Ofrece_apoyo
            data['Ofrece_apoyo'] = 'Si' if apoyo_economico_value == 'Si' else 'No'
            
            # Si es 'Si', usar el valor del campo valor_apoyo_economico si viene, sino 0.01
            if apoyo_economico_value == 'Si':
                # Buscar el valor del apoyo económico en valor_apoyo_economico
                valor_apoyo = data.get('valor_apoyo_economico', None)
                if valor_apoyo is not None and valor_apoyo != '':
                    try:
                        # Convertir a decimal
                        from decimal import Decimal
                        data['apoyoEconomico'] = Decimal(str(valor_apoyo))
                    except (ValueError, TypeError):
                        data['apoyoEconomico'] = 0.01  # Valor por defecto si no se puede convertir
                else:
                    data['apoyoEconomico'] = 0.01  # Valor mínimo para indicar que sí hay apoyo
            else:
                data['apoyoEconomico'] = 0.00
            # Remover apoyo_economico y valor_apoyo_economico ya que no existen en la BD
            if 'apoyo_economico' in data:
                del data['apoyo_economico']
            if 'valor_apoyo_economico' in data:
                del data['valor_apoyo_economico']
        
        # Remover campos que no existen en la BD
        campos_a_remover = ['descripcion', 'fecha_inicio', 'fecha_fin']
        for campo in campos_a_remover:
            if campo in data:
                del data[campo]
        
        # Asegurar que programa_id sea un entero si viene como string
        if 'programa_id' in data and data['programa_id'] is not None:
            if isinstance(data['programa_id'], str):
                try:
                    data['programa_id'] = int(data['programa_id'])
                except (ValueError, TypeError):
                    pass
        
        # Establecer valores por defecto para campos requeridos si no están presentes
        # Esto ayuda a evitar errores de validación más adelante
        if 'nacional' not in data or data.get('nacional') is None or data.get('nacional') == '':
            data['nacional'] = 'No'
        
        if 'modalidad' not in data or data.get('modalidad') is None or data.get('modalidad') == '':
            data['modalidad'] = 'Presencial'
        
        # Asegurar que apoyoEconomico siempre tenga un valor decimal válido
        if 'apoyoEconomico' not in data or data.get('apoyoEconomico') is None:
            data['apoyoEconomico'] = 0.00
        else:
            # Asegurar que sea un número si viene como string
            try:
                if isinstance(data['apoyoEconomico'], str):
                    data['apoyoEconomico'] = float(data['apoyoEconomico'])
            except (ValueError, TypeError):
                data['apoyoEconomico'] = 0.00
        
        print(f"DATOS ANTES DE VALIDACION: {data}")
        
        # Validación explícita de empresa ANTES de llamar a super()
        # Ya debería estar mapeado en el bloque anterior, pero verificamos de nuevo
        if 'empresa' not in data or data.get('empresa') is None or data.get('empresa') == 0:
            print(f"❌ ERROR: empresa es requerido pero no está presente o es inválido")
            print(f"Datos completos recibidos: {data}")
            raise serializers.ValidationError({
                'empresa': 'El campo empresa es requerido. Asegúrate de estar autenticado como empresa.'
            })
        
        try:
            result = super().to_internal_value(data)
            print(f"VALIDACION EXITOSA: {result}")
            
            # Validación adicional después de la validación base
            # PrimaryKeyRelatedField convierte el ID a un objeto, verificar que esté presente
            empresa_obj = result.get('empresa')
            if empresa_obj is None:
                print(f"⚠ ADVERTENCIA: empresa no está en el resultado de validación")
                print(f"Resultado: {result}")
                raise serializers.ValidationError({
                    'empresa': 'El campo empresa es requerido y debe ser un ID válido de empresa.'
                })
            
            # Asegurar que empresa esté en el resultado (puede ser objeto o ID)
            if not hasattr(empresa_obj, 'empresa_id') and not hasattr(empresa_obj, 'pk'):
                # Si no es un objeto, intentar convertirlo
                try:
                    from .models import Empresas
                    empresa_id = int(empresa_obj) if not isinstance(empresa_obj, Empresas) else empresa_obj.pk
                    result['empresa'] = Empresas.objects.get(pk=empresa_id)
                    print(f"✓ empresa convertido a objeto: {result['empresa']}")
                except (ValueError, TypeError, Empresas.DoesNotExist):
                    raise serializers.ValidationError({
                        'empresa': 'El campo empresa debe ser un ID válido de empresa.'
                    })
            
            print(f"✓ Validación completa exitosa, empresa: {result.get('empresa')}")
            return result
        except serializers.ValidationError as ve:
            # Re-lanzar errores de validación con mejor mensaje
            print(f"Error de validación capturado: {ve.detail}")
            if 'empresa' in str(ve.detail) or 'empresa' in ve.detail:
                # Si ya es un error de empresa, re-lanzarlo tal cual
                raise
            raise serializers.ValidationError({
                'empresa': 'El campo empresa es requerido. Verifica que el ID de empresa sea válido.'
            })
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"ERROR EN VALIDACION: {e}")
            print(error_trace)
            raise serializers.ValidationError({
                'empresa': f'Error de validación: {str(e)}'
            })
    
    def validate_empresa(self, value):
        """
        Validación explícita del campo empresa
        """
        print(f"validate_empresa llamado con valor: {value}, tipo: {type(value)}")
        
        if value is None:
            raise serializers.ValidationError('El campo empresa es requerido.')
        
        # Si es un objeto Empresas, está bien
        if hasattr(value, 'empresa_id') or hasattr(value, 'pk'):
            print(f"✓ empresa es un objeto válido: {value}")
            return value
        
        # Si es un ID, intentar obtener el objeto
        try:
            from .models import Empresas
            empresa_id = int(value)
            empresa = Empresas.objects.get(pk=empresa_id)
            print(f"✓ empresa ID {empresa_id} encontrado: {empresa.nombre_comercial or empresa.razon_social}")
            return empresa
        except (ValueError, TypeError):
            raise serializers.ValidationError(f'El valor de empresa debe ser un ID válido, recibido: {value}')
        except Empresas.DoesNotExist:
            raise serializers.ValidationError(f'La empresa con ID {value} no existe en la base de datos.')

    def create(self, validated_data):
        """
        Crear una oferta mapeando correctamente los campos a los nombres de columna de la BD.
        El campo 'empresa' puede venir como ID (int) o como objeto Empresas.
        """
        print(f"Validated data recibido en create: {validated_data}")
        
        # Preparar datos para crear la oferta
        data_para_crear = {}
        
        # Mapear nacional (ya procesado en to_internal_value)
        # Asegurar que siempre sea 'No' o 'Si', nunca None o vacío
        nacional_value = validated_data.get('nacional', 'No')
        if nacional_value is None or nacional_value == '':
            nacional_value = 'No'
        elif nacional_value not in ['No', 'Si']:
            nacional_value = 'No'
        data_para_crear['nacional'] = nacional_value
        
        # Mapear nombre_responsable -> nombreTutor
        # Asegurar que siempre tenga un valor válido, nunca None o vacío
        nombre_tutor = None
        if 'nombre_responsable' in validated_data and validated_data['nombre_responsable']:
            nombre_tutor = str(validated_data['nombre_responsable']).strip()[:40]
        elif 'nombreTutor' in validated_data and validated_data['nombreTutor']:
            nombre_tutor = str(validated_data['nombreTutor']).strip()[:40]
        
        # Asegurar que nombreTutor nunca sea None, vacío o solo espacios
        if not nombre_tutor or nombre_tutor.strip() == '':
            nombre_tutor = 'Sin especificar'
        
        # Asegurar que no exceda 40 caracteres
        nombre_tutor = nombre_tutor[:40] if len(nombre_tutor) > 40 else nombre_tutor
        data_para_crear['nombreTutor'] = nombre_tutor
        
        # Mapear apoyoEconomico
        # Asegurar que siempre sea un decimal válido, nunca None
        from decimal import Decimal
        apoyo_economico = validated_data.get('apoyoEconomico')
        if apoyo_economico is None:
            apoyo_economico = Decimal('0.00')
        else:
            try:
                apoyo_economico = Decimal(str(apoyo_economico))
            except (ValueError, TypeError):
                apoyo_economico = Decimal('0.00')
        data_para_crear['apoyoEconomico'] = apoyo_economico
        
        # Mapear modalidad
        # Asegurar que siempre sea uno de los valores válidos del enum
        modalidad_value = validated_data.get('modalidad', 'Presencial')
        if modalidad_value is None or modalidad_value == '':
            modalidad_value = 'Presencial'
        elif modalidad_value not in ['Presencial', 'Virtual', 'Híbrido']:
            modalidad_value = 'Presencial'
        data_para_crear['modalidad'] = modalidad_value
        
        # Mapear empresa (ForeignKey) - CRÍTICO
        # Con PrimaryKeyRelatedField, validated_data['empresa'] puede ser un objeto Empresas o un ID
        empresa_value = validated_data.get('empresa')
        if not empresa_value:
            raise serializers.ValidationError({
                'empresa': 'El campo empresa es requerido'
            })
        
        # Si es un objeto, usarlo directamente; si es un ID, obtener el objeto
        if hasattr(empresa_value, 'empresa_id'):
            empresa_obj = empresa_value
            empresa_id = empresa_obj.empresa_id
        elif hasattr(empresa_value, 'pk'):
            empresa_obj = empresa_value
            empresa_id = empresa_obj.pk
        else:
            # Es un ID, necesitamos obtener el objeto
            from .models import Empresas
            try:
                empresa_id = int(empresa_value)
                empresa_obj = Empresas.objects.get(pk=empresa_id)
            except (ValueError, TypeError, Empresas.DoesNotExist) as e:
                raise serializers.ValidationError({
                    'empresa': f'La empresa con ID {empresa_value} no existe o es inválida.'
                })
        
        data_para_crear['empresa'] = empresa_obj
        print(f"✓ Empresa asignada: ID {empresa_id} ({empresa_obj.nombre_comercial or empresa_obj.razon_social})")
        
        # Mapear nombreEmpresa - CRÍTICO: debe tener un valor válido
        nombre_empresa = validated_data.get('nombreEmpresa')
        if not nombre_empresa or nombre_empresa == '':
            # Obtener nombreEmpresa de la empresa si no se proporcionó
            try:
                if hasattr(empresa_obj, 'nombre_comercial') and empresa_obj.nombre_comercial:
                    nombre_empresa = str(empresa_obj.nombre_comercial).strip()[:255]
                elif hasattr(empresa_obj, 'razon_social') and empresa_obj.razon_social:
                    nombre_empresa = str(empresa_obj.razon_social).strip()[:255]
                else:
                    nombre_empresa = 'Sin especificar'
            except Exception as e:
                print(f"Error al obtener nombre de empresa: {e}")
                nombre_empresa = 'Sin especificar'
        
        # Asegurar que nombreEmpresa no esté vacío
        if not nombre_empresa or nombre_empresa.strip() == '':
            nombre_empresa = 'Sin especificar'
        
        data_para_crear['nombreEmpresa'] = nombre_empresa[:255]  # Limitar a 255 caracteres
        
        # Mapear programa_id (ForeignKey opcional)
        if 'programa_id' in validated_data:
            programa_value = validated_data['programa_id']
            if programa_value is not None and programa_value != '':
                if hasattr(programa_value, 'programa_id') or hasattr(programa_value, 'pk'):
                    data_para_crear['programa_id'] = programa_value
                else:
                    from .models import Programas
                    try:
                        data_para_crear['programa_id'] = Programas.objects.get(pk=int(programa_value))
                    except (Programas.DoesNotExist, ValueError, TypeError):
                        data_para_crear['programa_id'] = None
            else:
                data_para_crear['programa_id'] = None
        else:
            data_para_crear['programa_id'] = None
        
        # Mapear Ofrece_apoyo
        # Si viene en validated_data, usarlo; si no, determinar basado en apoyoEconomico
        ofrece_apoyo_value = validated_data.get('Ofrece_apoyo', None)
        if ofrece_apoyo_value is None or ofrece_apoyo_value == '':
            # Si no viene explícitamente, determinar basado en apoyoEconomico
            # Si apoyoEconomico > 0, entonces Ofrece_apoyo = 'Si', sino 'No'
            if apoyo_economico and apoyo_economico > 0:
                ofrece_apoyo_value = 'Si'
            else:
                ofrece_apoyo_value = 'No'
        elif ofrece_apoyo_value not in ['Si', 'No']:
            ofrece_apoyo_value = 'No'
        data_para_crear['Ofrece_apoyo'] = ofrece_apoyo_value
        
        # Mapear brinda_eps
        # Asegurar que siempre sea 'Si' o 'No'
        brinda_eps_value = validated_data.get('brinda_eps', 'No')
        if brinda_eps_value is None or brinda_eps_value == '':
            brinda_eps_value = 'No'
        elif brinda_eps_value not in ['Si', 'No']:
            brinda_eps_value = 'No'
        data_para_crear['brinda_eps'] = brinda_eps_value
        
        # Remover campos que no existen en el modelo
        campos_permitidos = ['nacional', 'nombreTutor', 'apoyoEconomico', 'modalidad', 'nombreEmpresa', 'empresa', 'programa_id', 'Ofrece_apoyo', 'brinda_eps']
        campos_finales = {k: v for k, v in data_para_crear.items() if k in campos_permitidos}
        
        # Validar que todos los campos requeridos estén presentes y no sean None
        campos_requeridos = {
            'nacional': data_para_crear.get('nacional'),
            'nombreTutor': data_para_crear.get('nombreTutor'),
            'apoyoEconomico': data_para_crear.get('apoyoEconomico'),
            'modalidad': data_para_crear.get('modalidad'),
            'nombreEmpresa': data_para_crear.get('nombreEmpresa'),
            'empresa': data_para_crear.get('empresa')
        }
        
        for campo, valor in campos_requeridos.items():
            if valor is None:
                raise serializers.ValidationError({
                    campo: f'El campo {campo} es requerido y no puede ser None'
                })
        
        print(f"Creando oferta con campos: {list(campos_finales.keys())}")
        print(f"Valores: nacional={campos_finales.get('nacional')}, nombreTutor={campos_finales.get('nombreTutor')}, apoyoEconomico={campos_finales.get('apoyoEconomico')}, modalidad={campos_finales.get('modalidad')}, nombreEmpresa={campos_finales.get('nombreEmpresa')}")
        
        try:
            oferta = OfertasEmpresas.objects.create(**campos_finales)
            print(f"✓ Oferta creada exitosamente: ID {oferta.idOferta}")
            return oferta
        except Exception as e:
            import traceback
            error_trace = traceback.format_exc()
            print(f"Error al crear oferta: {e}")
            print(error_trace)
            print(f"Datos que se intentaron insertar: {campos_finales}")
            raise serializers.ValidationError({
                'error': f'Error al crear la oferta: {str(e)}',
                'details': str(e)
            })

    def to_representation(self, instance):
        # Convertir los datos a un formato más amigable para el frontend
        data = super().to_representation(instance)
        
        # Mapear idOferta a oferta_id para compatibilidad con el frontend
        if 'idOferta' in data:
            data['oferta_id'] = data['idOferta']
        
        # Mapear Ofrece_apoyo a apoyo_economico para el frontend
        if 'Ofrece_apoyo' in data:
            data['apoyo_economico'] = data['Ofrece_apoyo']
        
        # Mapear brinda_eps para asegurar que esté en la respuesta
        if 'brinda_eps' in data:
            data['brinda_eps'] = data['brinda_eps']
        
        # Mapear nombreTutor a nombre_responsable
        if 'nombreTutor' in data:
            data['nombre_responsable'] = data['nombreTutor']
        
        # Mapear nacional a tipo_oferta
        if 'nacional' in data:
            if data['nacional'] == 'Si':
                data['tipo_oferta'] = 'Nacional'
            elif data['nacional'] == 'No':
                data['tipo_oferta'] = 'Internacional'
        
        # Mapear apoyoEconomico a valor_apoyo_economico si Ofrece_apoyo es 'Si'
        if 'apoyoEconomico' in data and 'Ofrece_apoyo' in data:
            if data.get('Ofrece_apoyo') == 'Si' and data.get('apoyoEconomico'):
                try:
                    # Convertir Decimal a float para JSON
                    from decimal import Decimal
                    if isinstance(data['apoyoEconomico'], Decimal):
                        data['valor_apoyo_economico'] = float(data['apoyoEconomico'])
                    else:
                        data['valor_apoyo_economico'] = float(data['apoyoEconomico'])
                except (ValueError, TypeError):
                    pass
        
        # Asegurar que empresa_id esté presente
        if 'empresa' in data:
            data['empresa_id'] = data['empresa']
        
        return data

