# Directorios a limpiar
$dirs = @("backup", "pg1-path")

# Recorrer cada directorio y eliminar su contenido
foreach ($dir in $dirs) {
    if (Test-Path -Path $dir) {
        Write-Host "Limpiando el directorio: $dir"
        Remove-Item -Path "$dir\*" -Recurse -Force
        
        # Crear el archivo .gitignore en el directorio
        $gitignorePath = Join-Path -Path $dir -ChildPath ".gitignore"
        if (-not (Test-Path -Path $gitignorePath)) {
            Write-Host "Creando .gitignore en: $dir"
            Add-Content -Path $gitignorePath -Value "*"
        }
    } else {
        Write-Host "Directorio $dir no encontrado."
    }
}

Write-Host "Limpieza y creación de .gitignore completa."
