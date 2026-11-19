# 1. Arquitectura

## Zonas de seguridad

| Zona | Red | Qué contiene | Nivel de confianza |
|------|-----|--------------|--------------------|
| **Internet / WAN** | `192.168.100.0/24` en el laboratorio (red NAT de VirtualBox; en la captura, FW1 obtiene `10.0.2.15/24` por DHCP) | Origen de los clientes VPN | Ninguna |
| **DMZ** | `192.168.1.0/24` | Servidor VPN (expuesto a Internet) | Baja |
| **LAN** | `192.168.0.0/24` | Proxy y clientes internos | Alta |

> 💡 **Por qué dos firewalls:** FW1 protege la DMZ frente a Internet y FW2 protege la LAN frente a la DMZ. Aunque el servidor VPN —el equipo expuesto— se viera comprometido, un atacante seguiría teniendo que atravesar un segundo firewall con reglas distintas para llegar a la LAN.

## Direccionamiento

| Dispositivo | Interfaz | Red / IP |
|-------------|----------|----------|
| **FW1** (pfSense externo) | WAN | Red NAT (`192.168.100.0/24` en el esquema original) |
| | DMZ | `192.168.1.1/24` |
| **FW2** (pfSense interno) | DMZ | `192.168.1.2/24` |
| | LAN | `192.168.0.1/24` |
| **Servidor VPN** | DMZ | `192.168.1.10/24` |
| **Servidor Proxy** | LAN | `192.168.0.10/24` |
| **Cliente interno** | LAN | `192.168.0.100/24` |
| **Túnel VPN** | — | `10.8.0.0/24` |

> ℹ️ **Nombres de interfaz en pfSense:** pfSense solo llama *WAN* y *LAN* a sus dos primeras interfaces. En FW1 la interfaz *LAN* de pfSense es la **DMZ**, y en FW2 la *WAN* de pfSense es la **DMZ** y su *LAN* es la LAN real. Por eso en las capturas de reglas aparecen esas etiquetas. Conviene renombrarlas a `DMZ`/`LAN` en *Interfaces → Assignments → Description*.

## Política de tráfico

| Origen | Destino | Permitido | Dónde se aplica |
|--------|---------|-----------|-----------------|
| Internet | Servidor VPN `192.168.1.10`, UDP 1194 | ✅ | FW1 (WAN) |
| DMZ | Internet | ✅ | FW1 (DMZ) |
| DMZ (VPN `192.168.1.10`) | Proxy `192.168.0.10`, TCP 3128 | ✅ | FW2 (DMZ) |
| DMZ | resto de la LAN | ❌ | FW2 (DMZ) |
| Cliente interno | Proxy `192.168.0.10`, TCP 3128 | ✅ | FW2 (LAN) |
| Proxy | Internet, TCP 80 y 443 | ✅ | FW2 (LAN) |
| Cliente interno | Internet directo | ❌ en el diseño objetivo ⚠️ (en la práctica original seguía permitido por la regla *Default allow LAN to any*; ver [mejoras](./07-problemas-y-mejoras.md)) | FW2 (LAN) |

## Flujos principales

**Navegación interna:** Cliente → *Proxy (3128)* → FW2 → FW1 (NAT) → Internet. El proxy aplica la lista negra y los horarios, y deja registro de cada petición en `access.log`.

**Acceso VPN:** Cliente remoto → Internet → FW1 → Servidor VPN (UDP 1194). Dentro del túnel (`10.8.0.0/24`) solo se alcanza el proxy: el servidor VPN hace NAT de `10.8.0.0/24` hacia su IP `192.168.1.10`, y FW2 solo deja pasar esa IP hacia `192.168.0.10:3128`.
