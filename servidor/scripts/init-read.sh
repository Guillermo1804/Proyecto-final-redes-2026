#!/bin/bash
# init-red.sh — Verificación de red interna del contenedor

echo "[RED] Verificando red interna..."

echo "=== Hostname ==="
hostname

echo "=== IP asignada al contenedor ==="
hostname -I || true

echo "=== Interfaces de red ==="
ip addr || true

echo "=== Rutas ==="
ip route || true

echo "[RED] Verificación completada."