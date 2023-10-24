#cloud-config
users:
  - name: "${sudo_user}"
    groups: ["sudo"]
    sudo: "ALL=(ALL) NOPASSWD:ALL"
    shell: "/bin/bash"
    ssh_authorized_keys:
      - "${ssh_pubkey}"
%{ if nat == true }

packages: ['iptables-persistent']

%{ endif }
runcmd:
%{ if floating_ipv4 != "" }
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
%{ if nat == true }
  - |
    # enable NAT
    echo "net.ipv4.ip_forward=1" >/etc/sysctl.d/90-ipforward.conf
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE --random
    # Allow traffic from internal to external
    iptables -A FORWARD -i enp7s0 -o eth0 -j ACCEPT
    # Allow returning traffic from external to internal
    iptables -A FORWARD -i eth0 -o enp7s0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    # Drop all other traffic that shouldn't be forwarded
    iptables -A FORWARD -j DROP
    # persist
    iptables-save > /etc/iptables/rules.v4
%{ endif }
%{ endif }
%{ if floating_ipv4 == "" }
  - |
    cat <<EOF >> /etc/network/interfaces.d/gateway-ipv4.cfg
    # enable route to ipv4 default gateway
    auto enp7s0
    iface enp7s0 inet dhcp
    up ip route add default via 10.1.0.1 dev enp7s0
    EOF

    # Restart networking to apply the changes
    systemctl restart networking
%{ endif }

package_update: true
package_upgrade: true