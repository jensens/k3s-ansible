#cloud-config
users:
  - name: "ansible"
    groups: ["sudo"]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: "/bin/bash"
    ssh_authorized_keys:
      - "${ssh_pubkey}"

package_update: true
package_upgrade: true