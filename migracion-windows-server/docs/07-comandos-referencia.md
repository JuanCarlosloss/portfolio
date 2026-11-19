# 7. Referencia rápida de comandos

## Diagnóstico

| Comando | Para qué sirve |
|---------|----------------|
| `netdom query fsmo` | Muestra qué DC tiene cada rol FSMO |
| `repadmin /replsummary` | Resumen del estado de replicación entre DC |
| `dcdiag /v` | Diagnóstico completo de los controladores de dominio |
| `dfsrmig /getglobalstate` | Estado global de la migración FRS → DFSR |
| `dfsrmig /getmigrationstate` | Estado de cada DC en la migración |
| `nslookup <FQDN>` | Comprobar la resolución DNS |

## Roles FSMO

```text
:: ntdsutil (Schema Master y resto de roles)
ntdsutil
roles
connections
connect to server WIN16_11.msm.loc
quit
transfer schema master
quit
quit
```

```powershell
# Todos los roles de golpe (0 PDC, 1 RID, 2 Infraestructura, 3 Esquema, 4 Naming)
Move-ADDirectoryServerOperationMasterRole WS25 -OperationMasterRole 0,1,2,3,4 -Confirm:$false
```

## Roles y dominio

```powershell
Install-WindowsFeature AD-Domain-Services -IncludeManagementTools
Add-Computer -DomainName msm.loc -Credential MSM\Administrator -Restart
Install-ADDSDomainController -DomainName msm.loc -InstallDns -Credential (Get-Credential)
Uninstall-ADDSDomainController -DemoteOperationMasterRole:$false -Credential (Get-Credential)
```

## SYSVOL (FRS → DFSR)

```cmd
dfsrmig /setglobalstate 1
dfsrmig /setglobalstate 2
dfsrmig /setglobalstate 3
```

## Niveles funcionales

```powershell
Get-ADForest | Select-Object Name, ForestMode
Get-ADDomain | Select-Object Name, DomainMode
Set-ADForestMode -Identity msm.loc -ForestMode Windows2016Forest
Set-ADDomainMode -Identity msm.loc -DomainMode Windows2016Domain
```

> Los valores válidos de `-ForestMode`/`-DomainMode` dependen de la versión de PowerShell/Windows. Consulta `Get-Help Set-ADForestMode` en el servidor.
