# 7. Problemas detectados y mejoras

Resumen de las incidencias de la práctica original y de cómo quedan resueltas en esta versión.

## Problemas y correcciones

| # | Problema | Efecto | Corrección |
|---|----------|--------|------------|
| 1 | Lista negra con `facebook.com` (coincidencia exacta) | `www.facebook.com` no se bloqueaba | Dominios con punto inicial: `.facebook.com` ([`blacklist.txt`](../configs/blacklist.txt)) |
| 2 | `acl vpnnet src 192.168.1.10/24` | Squid avisa: *Netmask masks away part of the IP*; la ACL abarcaba toda la `/24` | `192.168.1.10/32` |
| 3 | `vpnnet` definida pero sin regla `http_access allow` | El tráfico de la VPN no estaba permitido en el proxy | Añadida `http_access allow vpnnet working_hours` |
| 4 | ACL horaria `MTWTF` | El jueves no quedaba cubierto (`T` = martes, `H` = jueves) | `MTWHF` |
| 5 | Regla *Pass* `*` → `*` en la interfaz DMZ de FW2 y bloqueo DMZ → LAN desactivado | Posible acceso DMZ → LAN completo | Reglas mínimas: solo `192.168.1.10 → 192.168.0.10:3128` y bloqueo con *log* ([ver](./03-firewalls-pfsense.md#33-reglas-recomendadas-fw2)) |
| 6 | *Default allow LAN to any* activa en FW2 | Los clientes saltaban el proxy y salían directos a Internet | Desactivarla; permitir solo cliente → proxy y proxy → Internet |
| 7 | Reglas de bloqueo DMZ → LAN duplicadas en FW1 | Reglas innecesarias (FW1 no tiene LAN) | Solo en FW2 |
| 8 | Solo regla de firewall WAN, sin *port forward* | El cliente VPN externo no alcanzaba el servidor | NAT → Port Forward UDP 1194 → `192.168.1.10`; desmarcar *Block private networks* en el laboratorio |
| 9 | Servicio OpenVPN comprobado con `openvpn.service` | Aparece *active (exited)* aunque el túnel no exista | Usar `openvpn@server` |
| 10 | NAT con interfaz `eth0` en la documentación | La interfaz real era `enp0s3` | Parámetro `IFACE` en [`vpn-nat.sh`](../configs/vpn-nat.sh) |
| 11 | Falta de pasos de PKI (certificados, DH, `ta.key`) | Servidor VPN no reproducible | Documentado en [5.2](./05-vpn-openvpn.md#52-infraestructura-de-clave-pública-easy-rsa) |
| 12 | Se esperaba ver el proxy como salto en `traceroute` | El proxy actúa en capa 7; no aparece | Se documenta la ruta real (FW2 → FW1) |
| 13 | Documentación con Ubuntu 22.04, 1 GB de RAM, etc., distinta a las VM reales | Inconsistencia | Tablas actualizadas con los datos de las capturas |

## Mejoras de seguridad recomendadas

- **Actualizar los sistemas:** Ubuntu 18.04 y Squid 3.5 están fuera de soporte; usar Ubuntu 22.04/24.04 con Squid 5/6 y OpenVPN 2.5+.
- **Un certificado por cliente VPN** y revocación con CRL; protegerlos con contraseña.
- **Autenticación en Squid** (por ejemplo `basic_ncsa_auth`) para identificar a cada usuario en los logs, en lugar de filtrar solo por IP.
- **Filtrar HTTPS con cuidado:** el bloqueo por dominio funciona sobre `CONNECT`; inspeccionar contenido requiere *SSL-Bump* y una CA propia, con implicaciones de privacidad.
- **Registro y *log* en el firewall:** activar *log* en las reglas de bloqueo de FW2 y revisar *Status → System Logs → Firewall*.
- **Endurecer SSH:** claves en lugar de contraseñas y acceso solo desde equipos de administración.
- **Copia de seguridad** de la configuración de pfSense (*Diagnostics → Backup & Restore*).

## Trabajo futuro

- [ ] Probar un cliente OpenVPN real de extremo a extremo y añadir las capturas.
- [ ] Repetir las pruebas de aislamiento con las reglas recomendadas.
- [ ] Añadir un segundo servicio en la DMZ (p. ej. un servidor web) para ilustrar la publicación segura.
- [ ] Automatizar el despliegue de Squid y OpenVPN (script o Ansible).
