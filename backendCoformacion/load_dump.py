#!/usr/bin/env python
"""
Script para cargar el dump SQL en la base de datos
"""
import pymysql
import sys

# Credenciales
DB_USER = 'coformacion_user'
DB_PASSWORD = 'Coformacion2024#Secure'
DB_HOST = '127.0.0.1'
DB_NAME = 'coformacion1'
DUMP_FILE = r'c:\Users\fredy\Pictures\Coformacion\CoformacionServer2\dump-coformacion1-202512091206.sql'

def load_sql_dump():
    """Carga el dump SQL en la base de datos"""
    try:
        conn = pymysql.connect(
            host=DB_HOST,
            user=DB_USER,
            password=DB_PASSWORD,
            database=DB_NAME,
            charset='utf8mb4'
        )
        cursor = conn.cursor()
        
        print("📖 Leyendo archivo SQL...")
        with open(DUMP_FILE, 'r', encoding='utf-8') as f:
            sql_content = f.read()
        
        # Dividir por statements y ejecutar
        statements = sql_content.split(';')
        executed = 0
        
        for statement in statements:
            statement = statement.strip()
            if statement:
                try:
                    cursor.execute(statement)
                    executed += 1
                except Exception as e:
                    print(f"⚠️  Error ejecutando statement: {str(e)[:100]}")
                    continue
        
        conn.commit()
        cursor.close()
        conn.close()
        
        print(f"✅ Dump cargado exitosamente!")
        print(f"   {executed} statements ejecutados")
        return True
        
    except FileNotFoundError:
        print(f"❌ Error: No se encontró {DUMP_FILE}")
        return False
    except Exception as e:
        print(f"❌ Error de conexión: {str(e)}")
        return False

if __name__ == '__main__':
    if load_sql_dump():
        sys.exit(0)
    else:
        sys.exit(1)
