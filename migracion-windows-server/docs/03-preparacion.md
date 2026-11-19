# 3. Preparación del entorno

## Copias de seguridad

- [ ] Backup completo del estado del sistema (System State)
- [ ] Backup de datos (shares, bases de datos…)
- [ ] Snapshot / imagen de la VM

## Servidor destino (Windows Server 2025)

- [ ] Instalación y actualizaciones
- [ ] Nombre, IP estática y DNS
- [ ] Unión al dominio
- [ ] Instalación de roles necesarios

## Preparación del origen

- [ ] Comprobar salud de AD (`dcdiag`, `repadmin /replsummary`)
- [ ] Migrar replicación SYSVOL de FRS a DFSR (`dfsrmig`)
- [ ] Actualizar niveles funcionales si procede

## Comandos ejecutados

```powershell
# Pega aquí los comandos relevantes
```
