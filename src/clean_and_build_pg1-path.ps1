# Directorio a limpiar
$dir = "pg1-path"

# Verificar si el directorio existe, si no, crearlo
if (-Not (Test-Path -Path $dir)) {
    Write-Host "El directorio $dir no existe. Creando..."
    New-Item -Path $dir -ItemType Directory
} else {
    Write-Host "Limpiando el directorio: $dir"
    Remove-Item -Path "$dir\*" -Recurse -Force
}

Write-Host "Limpieza y/o creación de pg1-path completada."
