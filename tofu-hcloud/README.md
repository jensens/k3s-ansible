# Provision Hetzner VMs and prepare for Ansible

## Prepare

- [Install OpenTofu](https://opentofu.org/docs/intro/install) on your local machine or a server used ofr provisioning and management task only.
- Install Python 3
- If not already there, create an ssh key-pair using `ssh-keygen`, preferably an `ed25519` key (but thats upon you).
- You need an Hetzner Cloud account. If you don't have one, [sign up](https://accounts.hetzner.com/).
- Create a project in the Hetzner Cloud Console and generate an API token - save this token!
- Clone this repository to your local machine or the server.
- In the directory `tofu-hcloud` run `tofu init` to initialize the project.

## Configure

Edit `variables.tf` according to your needs.
Alternatively you can pass the variables later on the command line.

## Check

Run `tofu plan` and enter your Hetzner token when prompted.
Alternatively you can pass the token on the command line: `tofu plan -var 'hcloud_token=VERY_SECRET_TOKEN'`.

Check the output, is this what you want to apply?

## Apply/ Deploy

*Attention*: **Hetzner charges you** for the servers and services you create!

Run `tofu apply` and enter your Hetzner token when prompted (or pass the variable as mentioned above).

Now watch the output and the project in your [Hetzner Cloud console](https://console.hetzner.cloud/).

Servers should be created as configured.

## Destroy

If you just tested this here, or want to destroy the cluster for some other reason, you can do so.

Run `tofu destroy` and enter your Hetzner token when prompted (or pass the variable as mentioned above).

Now everything got destroyed, **except the floating IPs**!
This is, because you may want to recreate the whole cluster, but don't want to loose the floating IPs.

You have to **remove them manually** in the Hetzner Cloud console.
Since they create costs as well, this is recommended if you do not need them anymore.

## Prepare Ansible inventory

To go on with Ansible and install K3S with the specific setup for HCloud, you need to prepare the Ansible inventory.
It is generated from the Terraform state file.

Run `./bin/gen-all-sh`.

This creates