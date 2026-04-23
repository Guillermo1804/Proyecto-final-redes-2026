#!/bin/bash
# ============================================================
# entrypoint.sh — Equivalente funcional al proceso de arranque
# En lugar de BIOS → GRUB → kernel → systemd, aquí tenemos:
# tini (PID 1) → entrypoint → supervisord → servicios
# ============================================================

echo "[ARRANQUE] Iniciando entorno servidor - $(date)"

# 1. Inicializar usuarios (equivale a configuración post-boot)
/opt/scripts/init-usuarios.sh

# 2. Montar/preparar volúmenes
/opt/scripts/init-filesystem.sh

# 3. Aplicar configuración de red interna
/opt/scripts/init-red.sh

# 4. Iniciar todos los servicios con supervisord
echo "[ARRANQUE] Lanzando servicios con supervisord..."
exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf