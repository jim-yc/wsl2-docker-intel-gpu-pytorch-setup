#!/bin/bash
set -e
export DEBIAN_FRONTEND=noninteractive
echo "tzdata tzdata/Areas select Asia" | debconf-set-selections
echo "tzdata tzdata/Zones/Asia select Taipei" | debconf-set-selections

apt-get update
apt-get install -y software-properties-common curl
add-apt-repository -y ppa:kobuk-team/intel-graphics
apt-get update
apt-get install -y libze1 intel-level-zero-gpu intel-opencl-icd clinfo libze-dev intel-ocloc

curl -LsSf https://astral.sh/uv/install.sh | sh
source $HOME/.local/bin/env
uv python install 3.12.10
uv pip install --python 3.12.10 --system --break-system-packages numpy pandas sympy pillow
uv pip install --python 3.12.10 --system --break-system-packages torch torchvision torchaudio --index-url https://download.pytorch.org/whl/xpu

apt-get clean
rm -rf /var/lib/apt/lists/*