from django.contrib import admin
from .models import Empresas

@admin.register(Empresas)
class EmpresasAdmin(admin.ModelAdmin):
    list_display = [
        'empresa_id', 'razon_social', 'nombre_comercial', 'sector', 'tamano', 'direccion_empresa',
        'ciudad_empresa', 'departamento_empresa', 'telefono_empresa', 'sitio_web', 'cuota_sena', 'numero_empleados',
        'estado_convenio', 'fecha_convenio', 'convenio_url', 'actividad_economica',
        'horario_laboral', 'trabaja_sabado', 'observaciones', 'estado', 'fecha_creacion',
        'fecha_actualizacion', 'nit_empresa'
    ]
    search_fields = ['razon_social', 'nombre_comercial', 'nit_empresa', 'ciudad_empresa', 'departamento_empresa']
    list_filter = ['estado_convenio', 'estado', 'sector', 'tamano']
