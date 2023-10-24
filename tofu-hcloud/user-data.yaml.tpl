#cloud-config
users:
  - name: "${sudo_user}"
    groups: ["sudo"]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: "/bin/bash"
    ssh_authorized_keys:
      - "${ssh_pubkey}"

%{ if floating_ip != "" }
runcmd:
  - |
    # Add an floating IP address
    cat <<EOF >> /etc/network/interfaces.d/floating-ip.cfg
    auto eth0:1
    iface eth0:1 inet static
    address ${floating_ip}
    netmask 32
    EOF

    # Restart networking to apply the changes
    systemctl restart networking
%{ endif }

package_update: true
package_upgrade: true