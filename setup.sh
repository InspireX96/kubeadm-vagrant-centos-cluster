#!/bin/sh

# install some tools
sudo yum install -y vim telnet bind-utils wget

sudo bash -c 'cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF'

# install and start docker (deprecated)
# sudo yum install -y docker
# sudo systemctl enable docker && sudo systemctl start docker
# Verify docker version is 1.12 and greater.

# install and start docker
sudo yum install -y yum-utils
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl enable docker && sudo systemctl start docker

sudo setenforce 0

# install kubeadm, kubectl, and kubelet.
sudo yum install -y kubelet kubeadm kubectl

# upgrade everying
sudo yum upgrade -y

sudo bash -c 'cat <<EOF >  /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward=1
EOF'
sudo sysctl --system

sudo systemctl stop firewalld
sudo systemctl disable firewalld
sudo swapoff -a

# kubelet config
sudo bash -c "echo KUBELET_EXTRA_ARGS=--node-ip=$( ip addr show eth1 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' ) --fail-swap-on=false --cgroup-driver=cgroupfs > /etc/sysconfig/kubelet"
