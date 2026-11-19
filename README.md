# Portfolio — Juan Carlos

Colección de mis proyectos y documentación técnica.

## 📚 Proyectos

| Proyecto | Descripción | Tecnologías |
|----------|-------------|-------------|
| [🖨️ ServiJam 3D (TFG)](./tfg-servijam3d/README.md) | Panel web para gestionar solicitudes de impresión 3D, integrado con Klipper/Moonraker. | PHP, MariaDB, Docker, Apache |
| [🪟 Migración Windows Server 2008 → 2025](./migracion-windows-server/README.md) | Guía con capturas de la migración de Active Directory de Windows Server 2008 R2 a 2025 (pasando por 2016). | Windows Server, Active Directory, DNS, DFSR, PowerShell |
| [🛡️ DMZ con doble firewall, VPN y proxy](./dmz-firewall-vpn-proxy/README.md) | Red segmentada en VirtualBox con dos firewalls pfSense, VPN OpenVPN en la DMZ y proxy Squid con filtrado. | pfSense, OpenVPN, Squid, Ubuntu, VirtualBox |

## 🗂️ Estructura del repositorio

```
.
├── tfg-servijam3d/            # Proyecto de fin de grado (código + Docker)
├── migracion-windows-server/  # Migración de AD: docs/, scripts/, evidencias/
└── dmz-firewall-vpn-proxy/    # Seguridad perimetral: docs/, configs/, evidencias/
```
