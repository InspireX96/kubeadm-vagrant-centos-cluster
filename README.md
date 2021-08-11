# Kubeadm Vagrant CentOS Cluster

## Setup Nodes Using Vagrant

Bring up there CentOS 7 VMs as k8s nodes

```bash
vagrant up
```


## Configuring K8s Master node

SSH into k8s master node:

```bash
vagrant ssh k8s-master
```

### Configuration


Modify file `/etc/sysconfig/kubelet` as:

```bash
KUBELET_EXTRA_ARGS=--node-ip=193.168.205.120 --fail-swap-on=false --cgroup-driver=cgroupfs
```

Run `ps -ef | grep kubelet` to check if args are applied


### Disable swap

```bash
sudo swapoff -a
```

Comment out every entry with `swap` in `/etc/fstab`

### Start k8s service

```bash
sudo systemctl enable kubelet && sudo systemctl start kubelet
```


### kubeadm init on master node

Init master node

```bash
sudo kubeadm init --pod-network-cidr 172.100.0.0/16 --apiserver-advertise-address 192.168.205.120
```

Follow the command line output and run the required commands, save it if necessary. It should be something like this:

```bash
Your Kubernetes master has initialized successfully!

To start using your cluster, you need to run the following as a regular user:

  mkdir -p $HOME/.kube
  sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
  sudo chown $(id -u):$(id -g) $HOME/.kube/config

You should now deploy a pod network to the cluster.
Run "kubectl apply -f [podnetwork].yaml" with one of the options listed at:
  https://kubernetes.io/docs/concepts/cluster-administration/addons/

You can now join any number of machines by running the following on each node
as root:

  kubeadm join 192.168.205.120:6443 --token ... \
  --discovery-token-ca-cert-hash sha256:...
```

Apply network addon

```bash
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"
```



## Join Worker Nodes

SSH into worker nodes

### Configuration


Modify file `/etc/sysconfig/kubelet` as:

```bash
KUBELET_EXTRA_ARGS=--node-ip=192.168.205.121 --fail-swap-on=false --cgroup-driver=cgroupfs
```

(In k8s-node2 set `--node-ip=192.168.205.122`)

Run `ps -ef | grep kubelet` to check if args are applied


### Disable swap

```bash
sudo swapoff -a
```

Comment out every entry with `swap` in `/etc/fstab`

### Start k8s service

```bash
sudo systemctl enable kubelet && sudo systemctl start kubelet
```


### Join worker nodes

```bash
sudo kubeadm join 192.168.205.120:6443 --token ... \
  --discovery-token-ca-cert-hash sha256:...
```

## Change Node Rules

```bash
kubectl label node k8s-master node-role.kubernetes.io/master=
kubectl label node k8s-node1 node-role.kubernetes.io/worker=
kubectl label node k8s-node2 node-role.kubernetes.io/worker=
```

The k8s cluster should be good to go! Run `kubectl get nodes` and check output, which should be like this:

```bash
[vagrant@k8s-master ~]$ kubectl get nodes
NAME         STATUS   ROLES    AGE   VERSION
k8s-master   Ready    master   8d    v1.18.2
k8s-node1    Ready    worker   8d    v1.18.2
k8s-node2    Ready    worker   8d    v1.18.2
```

## Connect to k8s API server locally

Follow this [https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#optional-proxying-api-server-to-localhost](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/#optional-proxying-api-server-to-localhost)

Or modify local kube config to match the config on the master node

## Reference

[https://github.com/udemy-course/Kubernetes-CN](https://github.com/udemy-course/Kubernetes-CN)