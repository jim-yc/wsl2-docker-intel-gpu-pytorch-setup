# WSL2 & Docker 環境下 PyTorch XPU 安裝指南 (Intel GPU)

本專案提供在 Windows WSL2 (Ubuntu) 以及 Docker 容器 中，配置 Intel PyTorch (XPU) 深度學習環境的詳細手把手安裝步驟。
適用於搭載 Intel Arc 獨立顯卡以及 Core Ultra 內顯的開發裝置。

## 實際測試環境，本人實測能跑

### 系統
- WSL2 Ubuntu 26.04 LTS (用 Ubuntu 24.04 會抓不到顯卡)

### GPU
- Intel Arc 140V

## 參考資料

[PyTorch* Prerequisites for Intel® GPUs](https://www.intel.com/content/www/us/en/developer/articles/tool/pytorch-prerequisites-for-intel-gpu/2-14.html)

## 一、在 WSL2 直接安裝

本節指引如何直接在 WSL2 的 Ubuntu 系統內配置 Intel oneAPI 環境。

### 1. 驗證 WSL2 成功掛載 Intel GPU

在 WSL2 終端機中執行以下命令，確認硬體渲染節點存在：

```bash
ls -al /dev/dxg
```

### 2. 安裝 Intel Compute Runtime 與 oneAPI

```bash
apt-get update
apt-get install -y software-properties-common curl
add-apt-repository -y ppa:kobuk-team/intel-graphics
apt-get update
apt-get install -y libze1 intel-level-zero-gpu intel-opencl-icd clinfo libze-dev intel-ocloc
```

### 3. 測試有抓到 GPU

```bash
clinfo -l
```

跑完後應該要顯示 `Platform #0: Intel(R) OpenCL Graphics ...`。

### 4. 安裝 pytorch-xpu

```bash
uv python install 3.12.10
uv pip install --python 3.12.10 numpy pandas sympy pillow
uv pip install --python 3.12.10 torch torchvision torchaudio --index-url https://download.pytorch.org/whl/xpu
```

### 5. 驗證安裝完成

```python
import torch
print(f"Intel XPU Available: {torch.xpu.is_available()}")
```

如果輸出`Intel XPU Available: True`表示安裝成功。

## 二、使用 Docker

從 Dockerfile 建立映像檔後在啟動容器時必須掛進設備和驅動資料夾。

```bash
--device /dev/dxg -v /usr/lib/wsl:/usr/lib/wsl
```