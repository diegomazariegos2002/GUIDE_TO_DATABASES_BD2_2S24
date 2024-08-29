# Ejecutar los scripts de limpieza
Write-Host "Ejecutando limpieza de backup..."
& .\clean_backup.ps1

Write-Host "Ejecutando limpieza de pg1-path..."
& .\clean_pg1_path.ps1

Write-Host "Limpieza completa."
