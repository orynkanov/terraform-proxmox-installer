#!/bin/bash

if [[ ! -f /etc/centos-release ]]; then
    echo OS not CentOS. This script only for CentOS!
    exit 1
fi

OSVER=$(grep -o '[0-9]' /etc/centos-release | head -n1)
if [[ $OSVER -eq 7 ]]; then
    yum install -y wget unzip
    yum install -y golang
    yum install -y make
elif [[ $OSVER -eq 8 ]]; then
    dnf install -y wget unzip
    dnf install -y golang
    dnf install -y make
fi

cd /opt || exit 1

if [[ ! -f /usr/local/bin/terraform ]]; then
    wget https://releases.hashicorp.com/terraform/0.13.1/terraform_0.13.1_linux_amd64.zip
    unzip terraform_0.13.1_linux_amd64.zip -d /usr/local/bin
    terraform version
fi

git clone https://github.com/Telmate/terraform-provider-proxmox.git
cd terraform-provider-proxmox || exit 1

go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provider-proxmox
go install github.com/Telmate/terraform-provider-proxmox/cmd/terraform-provisioner-proxmox
make

mkdir ~/.terraform.d/plugins
cp bin/terraform-provider-proxmox ~/.terraform.d/plugins
cp bin/terraform-provisioner-proxmox ~/.terraform.d/plugins
