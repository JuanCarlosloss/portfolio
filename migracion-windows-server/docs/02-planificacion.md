# 2. Planificación y estrategia

## Estrategia elegida

_Describe el enfoque: migración por etapas (2008 → 2012 R2/2016 → 2025) o directa con un servidor nuevo._

> Nota: Windows Server 2025 no permite actualización in-place directa desde 2008; se requiere migración side-by-side o upgrades intermedios. Los controladores de dominio de 2025 requieren nivel funcional de dominio/bosque 2016 como mínimo para ciertas características y la replicación DFSR de SYSVOL.

## Fases

| Fase | Descripción | Fecha |
|------|-------------|-------|
| 1 | Inventario y copias de seguridad | |
| 2 | Preparación del destino | |
| 3 | Migración de roles | |
| 4 | Validación | |
| 5 | Retirada del servidor antiguo | |

## Plan de rollback

_Cómo se vuelve atrás si algo falla (snapshots, backups, servidor antiguo mantenido en paralelo…)._
