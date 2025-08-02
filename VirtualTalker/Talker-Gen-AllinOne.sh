#!/bin/bash

# Talker-Gen-AllinOne.sh - 一键安装脚本
# 步骤1：更换apt源为清华大学镜像源

echo "=== Talker-Gen 一键安装脚本 ==="
echo "步骤1：更换apt源为清华大学镜像源"

# 检查是否为root用户
if [ "$EUID" -ne 0 ]; then
    echo "请使用root权限运行此脚本 (sudo ./Talker-Gen-AllinOne.sh)"
    exit 1
fi

# 询问是否更换apt源
read -p "是否更换apt源为清华大学镜像源？(Y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Nn]$ ]]; then
    # 备份原始sources.list
    echo "正在备份原始sources.list..."
    cp /etc/apt/sources.list /etc/apt/sources.list.backup.$(date +%Y%m%d_%H%M%S)

    # 检测Ubuntu版本
    UBUNTU_VERSION=$(lsb_release -cs)
    echo "检测到Ubuntu版本: $UBUNTU_VERSION"

    # 写入清华大学镜像源
    echo "正在更换为清华大学镜像源..."
    cat > /etc/apt/sources.list << EOF
# 清华大学镜像源
deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION-updates main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION-updates main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION-backports main restricted universe multiverse

deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION-security main restricted universe multiverse
deb-src https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ $UBUNTU_VERSION-security main restricted universe multiverse
EOF

    # 更新软件包列表
    echo "正在更新软件包列表..."
    apt update

    echo "apt源已成功更换为清华大学镜像源"
    echo "原始sources.list已备份到 /etc/apt/sources.list.backup.*"
else
    echo "跳过更换apt源步骤"
fi

cd VirtualTalker || exit

# 步骤2：克隆SadTalker仓库
echo "步骤2：克隆SadTalker仓库"
if [ ! -d "SadTalker" ]; then
    echo "正在克隆SadTalker仓库..."
    if ! git clone https://github.com/OpenTalker/SadTalker.git; then
        echo "错误：克隆SadTalker仓库失败"
        exit 1
    fi
else
    echo "SadTalker仓库已存在，跳过克隆步骤"
fi
echo "✅ SadTalker仓库克隆完成"


# 步骤3：安装Python依赖
echo "步骤3：安装Python依赖"

# 安装Python 3.8
echo "正在安装Python 3.8..."
apt update
apt install -y software-properties-common
add-apt-repository -y ppa:deadsnakes/ppa
apt update
apt install -y python3.8 python3.8-venv python3.8-dev python3-pip

# 检查Python 3.8是否安装成功
if ! command -v python3.8 &> /dev/null; then
    echo "错误：Python 3.8安装失败"
    exit 1
fi

echo "Python 3.8安装成功，版本：$(python3.8 --version)"

# 进入SadTalker目录
cd SadTalker || exit

# 检查虚拟环境是否存在
if [ ! -d "./venv" ]; then
    echo "正在创建Python虚拟环境..."
    python3.8 -m venv ./venv
else
    echo "虚拟环境已存在，跳过创建步骤"
fi

# 激活虚拟环境
source venv/bin/activate

# 升级pip并安装依赖
echo "正在安装Python依赖包..."
pip install --upgrade pip
pip install -r requirements.txt

# 安装PyTorch (CUDA 11.3版本)
echo "正在安装PyTorch..."
pip install torch==1.12.1+cu113 torchvision==0.13.1+cu113 torchaudio==0.12.1 --extra-index-url https://download.pytorch.org/whl/cu113

# 安装FFmpeg
echo "正在安装FFmpeg..."
apt install -y ffmpeg

export LD_LIBRARY_PATH=/usr/lib/wsl/lib:$LD_LIBRARY_PATH

echo "✅ Python环境和依赖安装完成"

# 步骤4：安装模型

echo "步骤4：安装模型（网络原因可能需要多次重试）"
chmod +x scripts/download_models.sh
bash scripts/download_models.sh
