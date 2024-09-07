#!/bin/bash

# 更新包索引并安装必要的依赖
sudo apt-get update
sudo apt-get install -y ca-certificates curl

# 获取当前的操作系统
os_name=$(grep '^ID=' /etc/os-release | cut -d'=' -f2 | tr -d '"')

# 创建keyrings目录
sudo install -m 0755 -d /etc/apt/keyrings

# 判断操作系统是 Ubuntu 还是 Debian
if [ "$os_name" = "ubuntu" ]; then
    # 下载Docker的GPG密钥
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
elif [ "$os_name" = "debian" ]; then
    # 下载Docker的GPG密钥
    sudo curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
else
    echo "Unsupported operating system: $os_name"
    exit 1
fi

# 添加通用的安全权限
sudo chmod a+r /etc/apt/keyrings/docker.asc

# 添加Docker的APT源
if [ "$os_name" = "ubuntu" ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
elif [ "$os_name" = "debian" ]; then
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
fi

# 更新包索引
sudo apt-get update

# 安装Docker和其依赖
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 下载并安装Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.6.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

echo "Docker and Docker Compose have been installed successfully!"
