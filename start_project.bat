@echo off
echo.
echo 🚀 Iniciando Proyecto de Coformacion
echo ==================================
echo.

REM Verificar si el directorio del backend existe
if not exist "backendCoformacion" (
    echo [ERROR] Directorio 'backendCoformacion' no encontrado!
    pause
    exit /b 1
)

REM Verificar si package.json existe
if not exist "package.json" (
    echo [ERROR] package.json no encontrado. ¿Estas en el directorio correcto del proyecto Angular?
    pause
    exit /b 1
)

echo [INFO] Preparando el entorno...

REM Verificar si node_modules existe
if not exist "node_modules" (
    echo [INFO] Instalando dependencias de Angular...
    call npm install
    if errorlevel 1 (
        echo [ERROR] Error instalando dependencias de Angular
        pause
        exit /b 1
    )
    echo [SUCCESS] Dependencias de Angular instaladas
) else (
    echo [SUCCESS] Dependencias de Angular ya estan instaladas
)

REM Verificar Python
python --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Python no esta instalado o no esta en el PATH
    pause
    exit /b 1
)
echo [SUCCESS] Python encontrado

REM Verificar Angular CLI
call ng version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Angular CLI no esta instalado. Instalalo con: npm install -g @angular/cli
    pause
    exit /b 1
)
echo [SUCCESS] Angular CLI encontrado

echo.
echo [INFO] Iniciando backend Django...
echo.

REM Cambiar al directorio del backend e iniciar Django
cd backendCoformacion
if not exist "manage.py" (
    echo [ERROR] manage.py no encontrado en backendCoformacion/
    cd ..
    pause
    exit /b 1
)

echo [INFO] Ejecutando migraciones...
python manage.py migrate

echo [SUCCESS] Iniciando servidor Django en http://127.0.0.1:8001
start "Django Server" cmd /k "python manage.py runserver 127.0.0.1:8001"

REM Volver al directorio principal
cd ..

REM Esperar un poco para que Django se inicie
timeout /t 3 /nobreak >nul

echo.
echo [INFO] Iniciando frontend Angular...
echo [SUCCESS] Iniciando servidor Angular en http://localhost:4201
start "Angular Server" cmd /k "ng serve --port 4201"

REM Esperar un poco para que Angular se inicie
timeout /t 3 /nobreak >nul

echo.
echo ==============================================
echo   🎉 ¡Servidores iniciados exitosamente!
echo ==============================================
echo.
echo Frontend Angular: http://localhost:4201
echo Backend Django:   http://127.0.0.1:8001
echo Admin Django:     http://127.0.0.1:8001/admin
echo API Endpoints:    http://127.0.0.1:8001/api/
echo Diagnostico:      http://localhost:4201/diagnostico
echo.
echo Se abrieron dos ventanas de comandos:
echo - Una para el servidor Django (puerto 8001)
echo - Una para el servidor Angular (puerto 4200)
echo.
echo Para detener los servidores, cierra ambas ventanas
echo o presiona Ctrl+C en cada una.
echo.
echo Presiona cualquier tecla para cerrar esta ventana...
pause >nul 