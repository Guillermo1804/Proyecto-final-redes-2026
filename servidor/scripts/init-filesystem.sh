#!/bin/bash
# init-filesystem.sh — Configuración de volúmenes y cuotas

echo "[FILESYSTEM] Preparando sistemas de archivos..."

# ── Estructura de directorios ─────────────────────────────────────
mkdir -p /datos/{admins,devs,publico,backups}
mkdir -p /respaldos/{diarios,semanales,mensuales}
mkdir -p /var/log/proyecto

# ── Permisos ──────────────────────────────────────────────────────
chmod 750 /datos/admins /datos/devs
chmod 755 /datos/publico
chmod 700 /respaldos

# ── Quotas simuladas (límites en bash sin kernel quota) ───────────
# En Docker sin soporte de kernel quota, usamos du + alertas en cron
cat > /opt/scripts/check-quota.sh << 'EOF'
#!/bin/bash
LIMITE_MB=500
USUARIO=$1
DIR_USUARIO="/datos/devs"

USO_MB=$(du -sm "$DIR_USUARIO" 2>/dev/null | awk '{print $1}')
if [ "$USO_MB" -gt "$LIMITE_MB" ]; then
    echo "[QUOTA ALERT] $DIR_USUARIO usa ${USO_MB}MB (límite: ${LIMITE_MB}MB)" \
        >> /var/log/proyecto/quota-alerts.log
fi
EOF
chmod +x /opt/scripts/check-quota.sh

# ── Información del filesystem (para el informe) ──────────────────
echo "=== Uso de volúmenes ==="
df -h /datos /respaldos

echo "=== Inodos disponibles ==="
df -i /datos

echo "[FILESYSTEM] Listo."