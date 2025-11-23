#!/usr/bin/env bash
set -e

LOGFILE="install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Starting environment check ====="

# ---- Helper ----
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

log_version() {
    local name=$1
    local cmd=$2
    echo "[VERSION] $name: $($cmd)"
}

# ======================================================
# 1. Install Docker
# ======================================================
echo "[CHECK] Docker"
if command_exists docker; then
    echo "[OK] Docker already installed"
else
    echo "[INSTALL] Docker"
    sudo apt update -y
    sudo apt install -y ca-certificates curl gnupg lsb-release
    sudo mkdir -p /etc/apt/keyrings

    curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    echo \
        "deb [arch=$(dpkg --print-architecture) \
signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu \
$(lsb_release -cs) stable" \
        | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null

    sudo apt update -y
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    echo "[DONE] Docker installed"
fi

log_version "Docker" "docker --version"

# ======================================================
# 2. Install Docker Compose
# ======================================================
echo "[CHECK] Docker Compose"
if command_exists docker-compose; then
    echo "[OK] Docker Compose installed"
else
    echo "[INSTALL] Docker Compose"
    sudo curl -L \
    "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
    -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "[DONE] Docker Compose installed"
fi

log_version "Docker Compose" "docker-compose --version"

# ======================================================
# 3. Install Python 3.9+
# ======================================================
echo "[CHECK] Python version"
if command_exists python3; then
    VERSION=$(python3 - <<EOF
import sys
print(sys.version_info.major*100 + sys.version_info.minor)
EOF
)
    if [ "$VERSION" -ge 309 ]; then
        echo "[OK] Python detected: $(python3 --version)"
    else
        echo "[INSTALL] Python >= 3.9 required, installing..."
        sudo apt update -y
        sudo apt install -y python3 python3-pip python3-venv
    fi
else
    echo "[INSTALL] Python not found, installing..."
    sudo apt update -y
    sudo apt install -y python3 python3-pip python3-venv
fi

log_version "Python" "python3 --version"

# ======================================================
# 4. Pip
# ======================================================
echo "[CHECK] Pip"
if command_exists pip3; then
    echo "[OK] Pip is installed"
else
    echo "[INSTALL] Pip"
    sudo apt install -y python3-pip
fi

log_version "pip" "pip3 --version"

# ======================================================
# 5. Install ML Dependencies
# ======================================================
echo "[CHECK] Python ML packages"

check_python_pkg() {
    python3 - <<EOF
import importlib
try:
    importlib.import_module("$1")
    print("OK")
except ImportError:
    print("MISSING")
EOF
}

install_pkg_if_missing() {
    PKG="$1"
    STATUS=$(check_python_pkg "$PKG")
    if [[ "$STATUS" == "MISSING" ]]; then
        echo "[INSTALL] Installing $PKG..."
        pip3 install "$PKG"
    else
        echo "[OK] $PKG already installed"
    fi
}

install_pkg_if_missing "torch"
install_pkg_if_missing "torchvision"
install_pkg_if_missing "Pillow"

# Version logging
echo "[VERSION] torch: $(python3 -c "import torch; print(torch.__version__)")"
echo "[VERSION] torchvision: $(python3 -c "import torchvision; print(torchvision.__version__)")"
echo "[VERSION] Pillow: $(python3 -c "import PIL; print(PIL.__version__)")"

echo "===== Setup complete! Log saved to $LOGFILE ====="
