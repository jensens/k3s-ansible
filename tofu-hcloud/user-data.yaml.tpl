#cloud-config
users:
  - name: "${sudo_user}"
    groups: ["sudo"]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: "/bin/bash"
    ssh_authorized_keys:
      - "${ssh_pubkey}"

%{ if floating_ipv4 != "" }
runcmd:
  - |
    # Add an floating IP address
    cat <<EOF >> /etc/network/interfaces.d/floating-ipv4.cfg
    auto eth0:0
    iface eth0:0 inet static
    address ${floating_ipv4}
    netmask 32
    EOF

    cat <<EOF >> /etc/network/interfaces.d/floating-ipv6.cfg
    auto eth0:1
    iface eth0:1 inet6 static
    address ${floating_ipv6}1
    netmask 64
    EOF

    # Restart networking to apply the changes
    systemctl restart networking
%{ endif }

package_update: true
package_upgrade: true