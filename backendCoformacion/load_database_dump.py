#!/usr/bin/env python
"""
Script para cargar el dump SQL del database en la base de datos existente
"""
import os
import subprocess
import sys

# Credenciales de la base de datos
DB_USER = 'coformacion_user'
DB_PASSWORD = 'Coformacion2024#Secure'
DB_HOST = '127.0.0.1'
DB_NAME = 'coformacion1'
DUMP_FILE = 'dump-coformacion1-202512091206.sql'  # Ajusta el nombre del archivo

def load_dump():
    """Carga el dump SQL en la base de datos"""
    try:
        # Comando para Windows
        cmd = [
            'mysql',
            f'-h{DB_HOST}',
            f'-u{DB_USER}',
            f'-p{DB_PASSWORD}',
            DB_NAME
        ]
        
        # Leer el archivo del dump
        with open(DUMP_FILE, 'r', encoding='utf-8') as f:
            dump_content = f.read()
        
        # Ejecutar el dump
        process = subprocess.Popen(
            cmd,
            stdin=subprocess.PIPE,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        
        stdout, stderr = process.communicate(input=dump_content)
        
        if process.returncode == 0:
            print("✅ Dump cargado exitosamente!")
            return True
        else:
            print(f"❌ Error al cargar el dump: {stderr}")
            return False
            
    except FileNotFoundError:
        print(f"❌ Error: No se encontró el archivo {DUMP_FILE}")
        return False
    except Exception as e:
        print(f"❌ Error: {str(e)}")
        return False

if __name__ == '__main__':
    if load_dump():
        print("\nAhora necesitas actualizar tus modelos de Django para que")
        print("coincidan con el esquema de la base de datos.")
        sys.exit(0)
    else:
        sys.exit(1)
