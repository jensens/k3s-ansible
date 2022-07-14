# -*- mode: ruby -*-
# vi: set ft=ruby :


servers = {
  "servers" => {
    "instances" => 3,
    "cpus" => 2,
    "memory" => 2048,
    "ipoffset" => 10
  },
  "agents" => {
    "instances" => 2,
    "cpus" => 1,
    "memory" => 1024,
    "ipoffset" => 110
  }
}

Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  servers.each do |groupname, group|
    group["instances"].times { |i|
      config.vm.define "node-#{groupname}-#{i}", primary: false, autostart: true do |node|

        node.vm.hostname = "#{groupname}-#{i}"
        node.vm.box = "generic/debian11"

        node.vm.provider "virtualbox" do |vb|
          vb.name = "Debian 11 - #{groupname} #{i}"
          vb.cpus = group["cpus"]
          vb.memory = group["memory"]
        end

        node.vm.provider "libvirt" do |lv|
          lv.title = "Debian 11 - #{groupname} #{i}"
          lv.cpus = group["cpus"]
          lv.memory = group["memory"]
        end

        node.vm.network "private_network", ip: "10.0.1.#{group["ipoffset"] + i}", netmask: "255.255.255.0"

      end
    }
  end
  # config.vm.provision "ansible" do |ansible|
  #   ansible.playbook = "playbook.yml"
  #   ansible.groups["all"] = []
  #   servers.each do |groupname, group|
  #     ansible.groups[groupname] = new Array
  #     group["instances"].times { |i|
  #       servername = "#{groupname}-#{i}"
  #       ansible.groups[groupname].append(servername)
  #       ansible.groups["all"].append(servername)
  #     }
  #   end
  # end
end
