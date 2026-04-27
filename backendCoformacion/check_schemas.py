#!/usr/bin/env python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_uniempresarial.settings')
django.setup()

from django.db import connection

tables = [
    'materias_nucleo', 'objetivos_aprendizaje', 'ofertas_empresas', 'plantillas_correo',
    'proceso_coformacion', 'procesos_coformacion', 'docentes',
    'cortes_coformacion', 'documentos_proceso', 'tipos_actividad',
    'calendario_actividades', 'historial_comunicaciones', 'estado_proceso',
    'acompañamiento_estudiantil_coformacion', 'contactos_empresa'
]

cursor = connection.cursor()
for table in tables:
    try:
        cursor.execute(f'DESCRIBE {table}')
        rows = cursor.fetchall()
        print(f'\n{table}:')
        for row in rows:
            print(f'  {row[0]} ({row[1]})')
    except Exception as e:
        print(f'\n{table}: ERROR - {e}')
