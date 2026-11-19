# Comprueba el estado de Active Directory antes y después de cada paso de la migración.
# Requiere el módulo ActiveDirectory (RSAT) y ejecutarse como administrador del dominio.

Import-Module ActiveDirectory

Write-Host "`n== Roles FSMO ==" -ForegroundColor Cyan
netdom query fsmo

Write-Host "`n== Niveles funcionales ==" -ForegroundColor Cyan
Get-ADForest | Select-Object Name, ForestMode
Get-ADDomain | Select-Object Name, DomainMode

Write-Host "`n== Controladores de dominio ==" -ForegroundColor Cyan
Get-ADDomainController -Filter * |
    Select-Object Name, OperatingSystem, IsGlobalCatalog, Site

Write-Host "`n== Replicación ==" -ForegroundColor Cyan
repadmin /replsummary

Write-Host "`n== SYSVOL (FRS/DFSR) ==" -ForegroundColor Cyan
dfsrmig /getglobalstate

Write-Host "`n== Servicios DFS ==" -ForegroundColor Cyan
Get-Service DFSR, DFS -ErrorAction SilentlyContinue |
    Select-Object Name, Status, StartType
