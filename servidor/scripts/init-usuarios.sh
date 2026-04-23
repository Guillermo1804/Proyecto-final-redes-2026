#!/bin/bash
# init-usuarios.sh — Crear usuarios, grupos y políticas de acceso

echo "[USUARIOS] Configurando usuarios y grupos..."

# ── Grupos ───────────────────────────────────────────────────────
groupadd -f admins
groupadd -f desarrolladores
groupadd -f auditores

# ── Usuarios ─────────────────────────────────────────────────────
# Usuario administrador
if ! id "adminuser" &>/dev/null; then
    useradd -m -s /bin/bash -G admins,sudo adminuser
    echo "adminuser:Admin123!" | chpasswd
    echo "[USUARIOS] Creado: adminuser"
fi

# Usuario desarrollador
if ! id "devuser" &>/dev/null; then
    useradd -m -s /bin/bash -G desarrolladores devuser
    echo "devuser:Dev123!" | chpasswd
    echo "[USUARIOS] Creado: devuser"
fi

# Usuario auditor (solo lectura)
if ! id "auditor" &>/dev/null; then
    useradd -m -s /bin/bash -G auditores auditor
    echo "auditor:Audit123!" | chpasswd
    echo "[USUARIOS] Creado: auditor"
fi

# ── Permisos de sudoers ───────────────────────────────────────────
echo "%admins ALL=(ALL) ALL" > /etc/sudoers.d/admins
echo "%desarrolladores ALL=(ALL) NOPASSWD: /usr/bin/git, /usr/bin/npm" > /etc/sudoers.d/devs
chmod 440 /etc/sudoers.d/admins /etc/sudoers.d/devs

# ── Directorios con permisos diferenciados ────────────────────────
mkdir -p /datos/admins /datos/devs /datos/publico

chown root:admins /datos/admins && chmod 770 /datos/admins
chown root:desarrolladores /datos/devs && chmod 770 /datos/devs
chown root:root /datos/publico && chmod 775 /datos/publico

echo "[USUARIOS] Configuración completada."

# Mostrar resumen (visible en los logs = evidencia para el informe)
echo "=== /etc/passwd (usuarios del proyecto) ==="
grep -E "adminuser|devuser|auditor" /etc/passwd

echo "=== /etc/group (grupos del proyecto) ==="
grep -E "admins|desarrolladores|auditores" /etc/group