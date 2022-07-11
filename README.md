# Build a Kubernetes cluster using k3s via Ansible on Hetzner Cloud

Original Author: <https://github.com/itwars>

Modification with hetzner-cloud/terraform and using etcd by <https://github.com/jensens>

## K3s Ansible Playbook

Build a Kubernetes cluster using Ansible with k3s. The goal is easily install a Kubernetes cluster on machines running:

- [X] Debian
- [X] Ubuntu
- [ ] CentOS

on processor architecture:

- [X] x64
- [ ] arm64
- [ ] armhf

(unchecked options untested)

## System requirements

Deployment environment must have Ansible 2.4.0+
Server-nodes and agent-nodes must have passwordless SSH access (Terraform enables this)

## Usage

- On [Hetzner Cloud](https://www.hetzner.com/cloud) create a empty cloud config with a read-write token.
- Install [Terraform](https://www.terraform.io/)
- Create a ssh keypair `~/.ssh/tf_hetzner[.pub]`
- In directory `terrform-hcloud`
  - execute `terraform plan` to see what will happen and `terraform apply` to get the cluster up (enter Hetzner token if prompted).
  - execute `./bin/gen-all.sh` to generate inventory and configuration.
- In root directory run `ansible site.cfg`

## Get IP-Address

- run `grep -A 1 "\[server\]" inventory/hcloud/hosts.ini` to get the ip address of the initial server node. Further used here as `IPADDRESS`.
- run `ssh ansible@IPADDRESS` to connect to the server (usually not needed).
- open `inventory/hcloud/hosts.ini` to lookup all other IPs.

## Kubeconfig

To get access to your **Kubernetes** cluster just

```bash
scp ansible@IPADDRESS:~/.kube/config ~/.kube/config
```

## Uninstall

In `terraform-hcloud` directory run `terraform destroy`.