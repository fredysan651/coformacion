@echo off
REM Script para ejecutar Django en http://127.0.0.1:8001/

cd /d "%~dp0backendCoformacion"

echo ========================================
echo Iniciando Django en http://127.0.0.1:8001/
echo ========================================

python manage.py runserver 127.0.0.1:8001

pause
