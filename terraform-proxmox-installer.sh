#!/bin/bash

dnf install -y wget unzip
dnf install -y golang
dnf install -y make

cd /opt || exit 1

if [[ ! -f /usr/local/bin/terraform ]]; then
    wget https://releases.hashicorp.com/terraform/0.12.28/terraform_0.12.28_linux_amd64.zip
    unzip terraform_*_linux_amd64.zip -d /usr/local/bin
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
