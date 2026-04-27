# Script para subir proyecto a twentybyte.com
# Guarda como: Upload-ToServer.ps1

# Configuración
$Server = "twentybyte.com"
$Username = "usuario"
$Password = "9999999999"
$LocalPath = "C:\Users\fredy\Pictures\Coformacion\CoformacionServer2"
$RemotePath = "/var/www/conformacion/"

Write-Host "🚀 Iniciando subida del proyecto a $Server..."
Write-Host "================================================"

# Instalar módulo Posh-SSH si no existe
if (-not (Get-Module -Name Posh-SSH -ListAvailable)) {
    Write-Host "📦 Instalando módulo Posh-SSH..." -ForegroundColor Cyan
    Install-Module -Name Posh-SSH -Force -Scope CurrentUser -Repository PSGallery
}

Import-Module Posh-SSH

# Crear credenciales
$SecurePassword = ConvertTo-SecureString -String $Password -AsPlainText -Force
$Credential = New-Object System.Management.Automation.PSCredential($Username, $SecurePassword)

try {
    # Conectar al servidor
    Write-Host "🔌 Conectando a $Server..." -ForegroundColor Yellow
    $Session = New-SSHSession -ComputerName $Server -Credential $Credential -AcceptKey -ErrorAction Stop
    
    # Crear directorio remoto si no existe
    Write-Host "📁 Preparando directorio remoto..." -ForegroundColor Yellow
    $Command = "mkdir -p $RemotePath"
    Invoke-SSHCommand -SSHSession $Session -Command $Command | Out-Null
    
    # Subir archivos
    Write-Host "📤 Subiendo archivos a $RemotePath..." -ForegroundColor Cyan
    Set-SCPFile -Session $Session -LocalFile "$LocalPath\*" -RemotePath $RemotePath -Recurse -ErrorAction Stop
    
    # Cerrar sesión
    Remove-SSHSession -Session $Session | Out-Null
    
    Write-Host "✅ ¡Subida completada exitosamente!" -ForegroundColor Green
    Write-Host "================================================"
    Write-Host "El proyecto está en: $RemotePath"
    Write-Host ""
    Write-Host "Próximos pasos en el servidor:"
    Write-Host "1. ssh usuario@twentybyte.com"
    Write-Host "2. cd /var/www/conformacion"
    Write-Host "3. chmod +x deploy-conformacion.sh"
    Write-Host "4. ./deploy-conformacion.sh"
    
}
catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
