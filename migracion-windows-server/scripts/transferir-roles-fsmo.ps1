# Transfiere los 5 roles FSMO al DC indicado.
# Uso: .\transferir-roles-fsmo.ps1 -Destino WS25
# Requiere el módulo ActiveDirectory y pertenecer a Enterprise Admins y Schema Admins.

param(
    [Parameter(Mandatory)]
    [string]$Destino
)

Import-Module ActiveDirectory

# 0 PDCEmulator, 1 RIDMaster, 2 InfrastructureMaster, 3 SchemaMaster, 4 DomainNamingMaster
Move-ADDirectoryServerOperationMasterRole -Identity $Destino -OperationMasterRole 0,1,2,3,4 -Confirm:$false

Write-Host "`nRoles tras la transferencia:" -ForegroundColor Cyan
netdom query fsmo
