#!/usr/bin/env bash
set -e

LOGFILE="install.log"
exec > >(tee -a "$LOGFILE") 2>&1

echo "===== Starting environment check ====="

# ---- Helpers ----
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

ensure_apt_updated=false
apt_update_once() {
    if [ "$ensure_apt_updated" = false ]; then
        echo "[APT] Updating package lists..."
        sudo apt update -y
        ensure_apt_updated=true
    fi
}

log_version() {
    echo "[VERSION] $1: $($2)"
}



# ==============  1. Install Docker  ====================================

echo "[CHECK] Docker"
if command_exists docker; then
    echo "[OK] Docker already installed"
else
    echo "[INSTALL] Docker"
    apt_update_once
    sudo apt install -y ca-certificates curl gnupg lsb-release

    # Key
    if [ ! -f /etc/apt/keyrings/docker.gpg ]; then
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
            | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    else
        echo "[SKIP] docker.gpg key already exists"
    fi

    # Repo
    if [ ! -f /etc/apt/sources.list.d/docker.list ]; then
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" \
            | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
    else
        echo "[SKIP] Docker apt repository already exists"
    fi

    apt_update_once
    sudo apt install -y docker-ce docker-ce-cli containerd.io
    echo "[DONE] Docker installed"
fi

log_version "Docker" "docker --version"



# ==============  2. Install Docker Compose  ==========================

echo "[CHECK] Docker Compose"
if command_exists docker-compose; then
    echo "[OK] Docker Compose already installed"
else
    echo "[INSTALL] Docker Compose"
    sudo curl -L \
        "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

log_version "Docker Compose" "docker-compose --version"



# ==============  3. Install Python 3.9+ =============================

echo "[CHECK] Python 3.9+"
if command_exists python3; then
    PYVER=$(python3 - <<EOF
import sys
print(sys.version_info.major*100 + sys.version_info.minor)
EOF
)
    if [ "$PYVER" -ge 309 ]; then
        echo "[OK] Python $(python3 --version) is sufficient"
    else
        echo "[INSTALL] Updating Python"
        apt_update_once
        sudo apt install -y python3 python3-pip python3-venv
    fi
else
    echo "[INSTALL] Installing Python"
    apt_update_once
    sudo apt install -y python3 python3-pip python3-venv
fi

log_version "Python" "python3 --version"



# ==============  4. PIP    =================================

echo "[CHECK] pip3"
if command_exists pip3; then
    echo "[OK] pip3 installed"
else
    echo "[INSTALL] pip3"
    apt_update_once
    sudo apt install -y python3-pip
fi

log_version "pip" "pip3 --version"



# ==============  5. Python ML Dependencies  ========================

echo "[CHECK] Python ML libs"

is_importable() {
    python3 - <<EOF
import importlib
try:
    importlib.import_module("$1")
    print("OK")
except ImportError:
    print("NO")
EOF
}

install_lib() {
    PKG="$1"
    if [[ "$(is_importable "$PKG")" == "OK" ]]; then
        echo "[OK] $PKG already installed"
    else
        echo "[INSTALL] $PKG"
        pip3 install "$PKG"
    fi
}

install_lib "torch"
install_lib "torchvision"
install_lib "Pillow"

echo "[VERSION] torch: $(python3 -c "import torch; print(torch.__version__)")"
echo "[VERSION] torchvision: $(python3 -c "import torchvision; print(torchvision.__version__)")"
echo "[VERSION] Pillow: $(python3 -c "import PIL; print(PIL.__version__)")"

echo "===== Setup complete! Log saved to $LOGFILE ====="
