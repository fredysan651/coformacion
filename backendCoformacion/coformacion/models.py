from django.db import models


class Roles(models.Model):
    rol_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50)
    descripcion = models.TextField(blank=True, null=True)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(blank=True, null=True)
    fecha_actualizacion = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'roles'


class Permisos(models.Model):
    permiso_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    modulo = models.CharField(max_length=50)
    descripcion = models.TextField(blank=True, null=True)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'permisos'


class RolesPermisos(models.Model):
    rol = models.ForeignKey(Roles, on_delete=models.CASCADE, db_column='rol_id', primary_key=True)
    permiso = models.ForeignKey(Permisos, on_delete=models.CASCADE, db_column='permiso_id')
    fecha_asignacion = models.DateTimeField(blank=True, null=True)

    class Meta:
        db_table = 'roles_permisos'
        managed = False

class TiposDocumento(models.Model):
    tipo_doc_id = models.AutoField(primary_key=True)
    codigo = models.CharField(max_length=20, unique=True)
    nombre = models.CharField(max_length=100)
    descripcion = models.TextField(blank=True, null=True)
    es_obligatorio = models.BooleanField(default=True)
    formato_url = models.CharField(max_length=255, blank=True, null=True)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'tipos_documento'


class Facultades(models.Model):
    facultad_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=255)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'facultades'


class Programas(models.Model):
    MODALIDAD_CHOICES = [
        ('Presencial', 'Presencial'),
        ('Virtual', 'Virtual'),
        ('Híbrido', 'Híbrido'),
    ]

    NIVEL_CHOICES = [
        ('Técnico', 'Técnico'),
        ('Tecnólogo', 'Tecnólogo'),
        ('Profesional', 'Profesional'),
        ('Especialización', 'Especialización'),
        ('Maestría', 'Maestría'),
    ]

    programa_id = models.AutoField(primary_key=True)
    codigo = models.CharField(max_length=20, unique=True)
    nombre = models.CharField(max_length=255)
    facultad_id = models.ForeignKey('Facultades', on_delete=models.RESTRICT, db_column='facultad_id')
    duracion_semestres = models.IntegerField()
    modalidad = models.CharField(max_length=10, choices=MODALIDAD_CHOICES)
    nivel = models.CharField(max_length=15, choices=NIVEL_CHOICES)
    resolucion_registro = models.CharField(max_length=100, blank=True, null=True)
    fecha_resolucion = models.DateField(blank=True, null=True)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'programas'


class MateriasNucleo(models.Model):
    materia_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    programa = models.ForeignKey(Programas, on_delete=models.DO_NOTHING, db_column='programa_id')

    class Meta:
        db_table = 'materias_nucleo'


class ObjetivosAprendizaje(models.Model):
    objetivo_id = models.AutoField(primary_key=True)
    descripcion = models.TextField()
    materia = models.ForeignKey(MateriasNucleo, on_delete=models.DO_NOTHING, db_column='materia_id')

    class Meta:
        db_table = 'objetivos_aprendizaje'


class Promociones(models.Model):
    promocion_id = models.AutoField(primary_key=True)
    descripcion = models.CharField(max_length=50, unique=True)

    class Meta:
        db_table = 'promociones'


class NivelesIngles(models.Model):
    nivel_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50, unique=True)

    class Meta:
        db_table = 'niveles_ingles'


class EstadosCartera(models.Model):
    estado_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50, unique=True)

    class Meta:
        db_table = 'estados_cartera'


class Coformacion(models.Model):
    id = models.AutoField(primary_key=True)
    nombre_completo = models.CharField(max_length=255)
    identificacion = models.CharField(max_length=20, unique=True)
    rol = models.CharField(max_length=100)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'coformacion'


class Estudiantes(models.Model):
    TIPO_DOCUMENTO_CHOICES = [
        ('CC', 'Cédula de Ciudadanía'),
        ('CE', 'Cédula de Extranjería'),
        ('PAS', 'Pasaporte'),
        ('TI', 'Tarjeta de Identidad'),
    ]

    GENERO_CHOICES = [
        ('M', 'Masculino'),
        ('F', 'Femenino'),
        ('O', 'Otro'),
    ]

    JORNADA_CHOICES = [
        ('Diurna', 'Diurna'),
        ('Nocturna', 'Nocturna'),
        ('Mixta', 'Mixta'),
    ]

    ESTADO_CHOICES = [
        ('Activo', 'Activo'),
        ('Inactivo', 'Inactivo'),
        ('Graduado', 'Graduado'),
        ('Retirado', 'Retirado'),
    ]

    estudiante_id = models.AutoField(primary_key=True)
    codigo_estudiante = models.CharField(max_length=20, unique=True)
    tipo_documento = models.CharField(max_length=3, choices=TIPO_DOCUMENTO_CHOICES)
    numero_documento = models.CharField(max_length=20, unique=True)
    apellidos = models.CharField(max_length=300, blank=True, null=True)
    nombres = models.CharField(max_length=300, blank=True, null=True)
    programa_id = models.ForeignKey('Programas', on_delete=models.RESTRICT, db_column='programa_id')
    jornada = models.CharField(max_length=8, choices=JORNADA_CHOICES)
    semestre = models.IntegerField()
    promocion_id = models.ForeignKey('Promociones', on_delete=models.SET_NULL, null=True, blank=True, db_column='promocion_id')
    fecha_nacimiento = models.DateField()
    nivel_ingles_id = models.ForeignKey('NivelesIngles', on_delete=models.SET_NULL, null=True, blank=True, db_column='nivel_ingles_id')
    genero = models.CharField(max_length=1, choices=GENERO_CHOICES)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    celular = models.CharField(max_length=20)
    email_institucional = models.EmailField(unique=True)
    email_personal = models.EmailField(blank=True, null=True)
    direccion = models.CharField(max_length=255, blank=True, null=True)
    ciudad = models.CharField(max_length=100, blank=True, null=True)
    foto = models.ImageField(upload_to='fotos_estudiantes/', blank=True, null=True)
    foto_url = models.CharField(max_length=255, blank=True, null=True)
    promedio_acumulado = models.DecimalField(max_digits=3, decimal_places=2, blank=True, null=True)
    estado = models.CharField(max_length=9, choices=ESTADO_CHOICES, default='Activo')
    fecha_ingreso = models.DateField()
    fecha_creacion = models.DateTimeField()
    fecha_actualizacion = models.DateTimeField()
    estado_cartera_id = models.ForeignKey('EstadosCartera', on_delete=models.SET_NULL, null=True, blank=True, db_column='estado_cartera_id')
    empresa_id = models.ForeignKey('Empresas', on_delete=models.SET_NULL, null=True, blank=True, db_column='empresa_id')
    eps_id = models.ForeignKey('EstudiantesEps', on_delete=models.SET_NULL, null=True, blank=True, db_column='eps_id')

    class Meta:
        db_table = 'estudiantes'



class ContactosDeEmergencia(models.Model):
    contacto_id = models.AutoField(primary_key=True)
    estudiante = models.ForeignKey(Estudiantes, on_delete=models.CASCADE, db_column='estudiante_id')
    nombres = models.CharField(max_length=300)
    apellidos = models.CharField(max_length=300)
    parentesco = models.CharField(max_length=200)
    celular = models.CharField(max_length=20)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    correo = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table = 'contactos_de_emergencia'


class EstudiantesEps(models.Model):
    eps_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=250, unique=True)
    codigo = models.CharField(max_length=400, blank=True, null=True)

    class Meta:
        db_table = 'estudiantes_eps'


class SectoresEconomicos(models.Model):
    sector_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)

    class Meta:
        db_table = 'sectores_economicos'


class TamanosEmpresa(models.Model):
    tamano_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)

    class Meta:
        db_table = 'tamanos_empresa'


class Empresas(models.Model):
    empresa_id = models.AutoField(primary_key=True)
    nit_empresa = models.CharField(max_length=20, blank=True, null=True)
    razon_social = models.CharField(max_length=255)
    nombre_comercial = models.CharField(max_length=255, blank=True, null=True)
    sector = models.ForeignKey('SectoresEconomicos', on_delete=models.RESTRICT, db_column='sector_id')
    tamano = models.ForeignKey('TamanosEmpresa', on_delete=models.RESTRICT, db_column='tamano_id')
    direccion_empresa = models.CharField(max_length=255)
    nombre_persona_contacto_empresa = models.CharField(max_length=255)
    numero_persona_contacto_empresa = models.CharField(max_length=255, blank=True, null=True)
    ciudad_empresa = models.CharField(max_length=100)
    departamento_empresa = models.CharField(max_length=100)
    cargo_persona_contacto_empresa = models.CharField(max_length=255)
    telefono_empresa = models.CharField(max_length=20, blank=True, null=True)
    email_empresa = models.CharField(max_length=255, blank=True, null=True)
    sitio_web = models.CharField(max_length=255, blank=True, null=True)
    cuota_sena = models.IntegerField(blank=True, null=True)
    numero_empleados = models.IntegerField(blank=True, null=True)
    estado_convenio = models.CharField(max_length=20, default='En Trámite')
    fecha_convenio = models.DateField(blank=True, null=True)
    convenio_url = models.CharField(max_length=255, blank=True, null=True)
    actividad_economica = models.TextField()
    horario_laboral = models.TextField(blank=True, null=True)
    trabaja_sabado = models.BooleanField(default=False)
    observaciones = models.TextField(blank=True, null=True)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField()
    fecha_actualizacion = models.DateTimeField()
    ciudad = models.CharField(max_length=100, blank=True, null=True)
    imagen_url_base64 = models.TextField(blank=True, null=True)

    class Meta:
        db_table = 'empresas'


class TiposContacto(models.Model):
    tipo_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=50, unique=True)

    class Meta:
        db_table = 'tipos_contacto'


class ContactosEmpresa(models.Model):
    contacto_id = models.AutoField(primary_key=True)
    empresa_id = models.ForeignKey(Empresas, on_delete=models.CASCADE, db_column='empresa_id')
    nombre = models.CharField(max_length=100)
    cargo = models.CharField(max_length=100, blank=True, null=True)
    area = models.CharField(max_length=100, blank=True, null=True)
    telefono = models.CharField(max_length=20, blank=True, null=True)
    celular = models.CharField(max_length=20, blank=True, null=True)
    email = models.EmailField()
    tipo = models.CharField(max_length=50, blank=True, null=True)
    es_principal = models.BooleanField(default=False)
    estado = models.BooleanField(default=True)
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'contactos_empresa'


class OfertasEmpresas(models.Model):
    MODALIDAD_CHOICES = [
        ('Presencial', 'Presencial'),
        ('Virtual', 'Virtual'),
        ('Híbrido', 'Híbrido'),
    ]

    NACIONAL_CHOICES = [
        ('No', 'No'),
        ('Si', 'Si'),
    ]

    APOYO_ECONOMICO_CHOICES = [
        ('Si', 'Si'),
        ('No', 'No'),
    ]

    idOferta = models.AutoField(primary_key=True, db_column='idOferta')
    nacional = models.CharField(max_length=2, choices=NACIONAL_CHOICES)
    nombreTutor = models.CharField(max_length=40)
    apoyoEconomico = models.DecimalField(max_digits=10, decimal_places=2, db_column='apoyoEconomico')
    modalidad = models.CharField(max_length=10, choices=MODALIDAD_CHOICES)
    nombreEmpresa = models.CharField(max_length=255)
    empresa = models.ForeignKey(Empresas, on_delete=models.CASCADE, db_column='empresa_id')
    programa_id = models.ForeignKey('Programas', on_delete=models.SET_NULL, null=True, blank=True, db_column='programa_id')
    Ofrece_apoyo = models.CharField(max_length=3, default='No', db_column='Ofrece_apoyo')
    brinda_eps = models.CharField(max_length=2, choices=APOYO_ECONOMICO_CHOICES, default='No', db_column='brinda_eps')

    class Meta:
        db_table = 'ofertasempresas'


class EstadoProceso(models.Model):
    estado_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)

    class Meta:
        db_table = 'estado_proceso'


class ProcesoCoformacion(models.Model):
    proceso_id = models.AutoField(primary_key=True)
    estudiante = models.ForeignKey('Estudiantes', on_delete=models.CASCADE, db_column='estudiante_id')
    empresa = models.ForeignKey('Empresas', on_delete=models.CASCADE, db_column='empresa_id')
    estado = models.ForeignKey(EstadoProceso, on_delete=models.SET_NULL, null=True, db_column='estado_id')
    fecha_inicio_fase_coformacion = models.DateField()
    fecha_fin_fase_practica = models.DateField(null=True, blank=True)
    fecha_ingreso_empresa = models.DateField(null=True, blank=True)
    fecha_finalizacion_empresa = models.DateField(null=True, blank=True)
    fecha_carta_presentacion = models.DateField(null=True, blank=True)
    horario = models.TextField(null=True, blank=True)
    forma_de_pago = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    trabaja_sabado = models.BooleanField(null=True, blank=True)
    salario = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    modalidad_vinculacion = models.CharField(max_length=10, null=True, blank=True)
    carta_presentacion_enviada = models.CharField(max_length=2, null=True, blank=True)
    carta_presentacion_recibida = models.CharField(max_length=2, null=True, blank=True)
    modalidad_coformacion = models.CharField(max_length=10, null=True, blank=True)
    observaciones = models.TextField(null=True, blank=True)
    fecha_creacion = models.DateTimeField(null=True, blank=True)
    fecha_actualizacion = models.DateTimeField(null=True, blank=True)

    class Meta:
        db_table = 'procesos_coformacion'


class DocumentosProceso(models.Model):
    ESTADO_CHOICES = [
        ('Pendiente', 'Pendiente'),
        ('En Revisión', 'En Revisión'),
        ('Aprobado', 'Aprobado'),
        ('Devuelto', 'Devuelto'),
    ]
    
    documento_id = models.AutoField(primary_key=True)
    proceso = models.ForeignKey('ProcesoCoformacion', on_delete=models.CASCADE, db_column='proceso_id', to_field='proceso_id')
    tipo_doc = models.ForeignKey('TiposDocumento', on_delete=models.RESTRICT, db_column='tipo_doc_id', to_field='tipo_doc_id')
    url_documento = models.CharField(max_length=255)
    fecha_envio = models.DateTimeField()
    fecha_revision = models.DateTimeField(null=True, blank=True)
    fecha_aprobacion = models.DateTimeField(null=True, blank=True)
    estado = models.CharField(max_length=20, choices=ESTADO_CHOICES, default='Pendiente')
    observaciones = models.TextField(null=True, blank=True)
    revisado_por = models.ForeignKey('Roles', on_delete=models.SET_NULL, null=True, blank=True, db_column='revisado_por')
    fecha_creacion = models.DateTimeField(auto_now_add=True)
    fecha_actualizacion = models.DateTimeField(auto_now=True)

    class Meta:
        db_table = 'documentos_proceso'


class TiposActividad(models.Model):
    tipo_id = models.AutoField(primary_key=True, db_column='tipo_id')
    nombre = models.CharField(max_length=100)
    descripcion = models.TextField()

    class Meta:
        db_table = 'tipos_actividad'


class CalendarioActividades(models.Model):
    actividad_id = models.AutoField(primary_key=True)
    descripcion = models.TextField()
    proceso = models.ForeignKey('ProcesosCoformacion', on_delete=models.CASCADE, db_column='proceso_id')
    tipo_actividad = models.ForeignKey(TiposActividad, on_delete=models.CASCADE, db_column='tipo_actividad_id')
    estado = models.CharField(max_length=20)
    fecha_actualizacion = models.DateTimeField()
    fecha_creacion = models.DateTimeField()

    class Meta:
        db_table = 'calendario_actividades'


class PlantillasCorreo(models.Model):
    plantilla_id = models.AutoField(primary_key=True)
    nombre = models.CharField(max_length=100)
    asunto = models.CharField(max_length=255)
    cuerpo = models.TextField()
    fecha_creacion = models.DateTimeField()

    class Meta:
        db_table = 'plantillas_correo'


class HistorialComunicaciones(models.Model):
    comunicacion_id = models.AutoField(primary_key=True)
    plantilla = models.ForeignKey(PlantillasCorreo, on_delete=models.CASCADE, db_column='plantilla_id')

    class Meta:
        db_table = 'historial_comunicaciones'


class Docentes(models.Model):
    docente_id = models.AutoField(primary_key=True)
    nombre_completo_docente = models.CharField(max_length=255)
    cargo_docente = models.CharField(max_length=255)
    telefono_docente = models.CharField(max_length=20, blank=True, null=True)
    email_docente = models.CharField(max_length=255, blank=True, null=True)

    class Meta:
        db_table = 'docentes'


class CortesCoformacion(models.Model):
    corte_id = models.AutoField(primary_key=True)
    numero_corte = models.CharField(max_length=255)
    fecha_inicio_corte = models.DateField()
    fecha_finalizacion_corte = models.DateField()

    class Meta:
        db_table = 'cortes_coformacion'


class ProcesosCoformacion(models.Model):
    MODALIDAD_CHOICES = [
        ('Presencial', 'Presencial'),
        ('Virtual', 'Virtual'),
        ('Híbrido', 'Híbrido'),
    ]
    
    CARTA_CHOICES = [
        ('Si', 'Si'),
        ('No', 'No'),
    ]
    
    proceso_id = models.AutoField(primary_key=True)
    estudiante = models.ForeignKey('Estudiantes', on_delete=models.CASCADE, db_column='estudiante_id')
    empresa = models.ForeignKey('Empresas', on_delete=models.CASCADE, db_column='empresa_id')
    estado = models.ForeignKey(EstadoProceso, on_delete=models.RESTRICT, db_column='estado_id')
    fecha_inicio_fase_coformacion = models.DateField()
    fecha_fin_fase_practica = models.DateField(blank=True, null=True)
    fecha_ingreso_empresa = models.DateField(blank=True, null=True)
    fecha_finalizacion_empresa = models.DateField(blank=True, null=True)
    fecha_carta_presentacion = models.DateField(blank=True, null=True)
    horario = models.TextField(blank=True, null=True)
    forma_de_pago = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    trabaja_sabado = models.BooleanField(blank=True, null=True)
    salario = models.DecimalField(max_digits=10, decimal_places=2, blank=True, null=True)
    modalidad_vinculacion = models.CharField(max_length=10, choices=MODALIDAD_CHOICES)
    carta_presentacion_enviada = models.CharField(max_length=2, choices=CARTA_CHOICES)
    carta_presentacion_recibida = models.CharField(max_length=2, choices=CARTA_CHOICES)
    modalidad_coformacion = models.CharField(max_length=10, choices=MODALIDAD_CHOICES)
    observaciones = models.TextField(blank=True, null=True)
    fecha_creacion = models.DateTimeField(blank=True, null=True)
    fecha_actualizacion = models.DateTimeField(blank=True, null=True)

    class Meta:
        indexes = [
            models.Index(fields=['fecha_inicio_fase_coformacion'], name='idx_fecha_inicio'),
        ]


class AcompanamientoEstudiantilCoformacion(models.Model):
    acompanamiento_id = models.AutoField(primary_key=True, db_column='acompanamiento_id')
    estudiante = models.ForeignKey('Estudiantes', on_delete=models.CASCADE, db_column='estudiante_id')
    proceso = models.ForeignKey(ProcesosCoformacion, on_delete=models.SET_NULL, null=True, blank=True, db_column='proceso_id')
    docente = models.ForeignKey(Docentes, on_delete=models.SET_NULL, null=True, blank=True, db_column='docente_id')
    empresa = models.ForeignKey('Empresas', on_delete=models.SET_NULL, null=True, blank=True, db_column='empresa_id')
    nombre_tutor_empresa = models.CharField(max_length=255, blank=True, null=True)
    cargo_tutor_empresa = models.CharField(max_length=255, blank=True, null=True)
    telefono_tutor_empresa = models.CharField(max_length=20, blank=True, null=True)
    email_tutor_empresa = models.CharField(max_length=255, blank=True, null=True)
    corte = models.ForeignKey(CortesCoformacion, on_delete=models.SET_NULL, null=True, blank=True, db_column='corte_id')

    class Meta:
        db_table = 'acompañamiento_estudiantil_coformacion'

