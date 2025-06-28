#!/bin/bash
sudo chmod 777 /dev/null
# sudo dnf update -y > /dev/null &
# wait
sudo dnf install nano git python3.12-pip -y > /dev/null &
wait
git clone https://github.com/kubernetes-sigs/kubespray.git &
wait
cp -rfp ~/kubespray/inventory/sample ~/kubespray/inventory/mycluster > /dev/null &
wait
pip3.12 install -r ~/kubespray/requirements.txt > /dev/null &
wait
sudo timedatectl set-timezone Europe/Moscow &
wait
mkdir ~/.kube
sudo chmod 600 ~/.ssh/id_ed25519 > /dev/null &
wait
echo | tee -a /home/alma/.ssh/id_ed25519 > /dev/null &
wait
