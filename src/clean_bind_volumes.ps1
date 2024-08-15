# Directorios a limpiar
$dirs = @("backup", "pg1-path")

# Recorrer cada directorio y eliminar su contenido
foreach ($dir in $dirs) {
    if (Test-Path -Path $dir) {
        Write-Host "Limpiando el directorio: $dir"
        Remove-Item -Path "$dir\*" -Recurse -Force
    } else {
        Write-Host "Directorio $dir no encontrado."
    }
}

Write-Host "Limpieza completa."
