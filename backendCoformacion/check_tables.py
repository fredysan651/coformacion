import django
import os
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'backend_uniempresarial.settings')
django.setup()

from django.db import connection

cursor = connection.cursor()
cursor.execute('SHOW TABLES')
tables = cursor.fetchall()
print('Tablas en la base de datos:')
for table in tables:
    print(f'  - {table[0]}')

# Verificar específicamente por tabla de estudiantes_eps
try:
    cursor.execute('SELECT * FROM estudiantes_eps LIMIT 1')
    print("\nTres existe: estudiantes_eps")
except Exception as e:
    print(f"\nTabla NO existe: estudiantes_eps")
    print(f"Error: {e}")
