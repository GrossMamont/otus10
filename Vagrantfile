# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {
  :rpm => {
        :box_name => "bento/almalinux-9.3",
        :vm_name => "202404.23.0",
        :net => [
           ["192.168.56.150",  2, "255.255.255.0", "intnet"],
        ]
  }
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|
   
      box.vm.box = boxconfig[:box_name]
      box.vm.host_name = boxconfig[:vm_name]
      
      box.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 4
       end

      boxconfig[:net].each do |ipconf|
        box.vm.network("private_network", ip: ipconf[0], adapter: ipconf[1], netmask: ipconf[2])
      end

      box.vm.provision "shell", inline: <<-SHELL
        mkdir -p ~root/.ssh
        cp ~vagrant/.ssh/auth* ~root/.ssh
        sudo sed -i 's/\#PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
        systemctl restart sshd
      SHELL

      box.vm.provision "main", type: "ansible" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.playbook = "playbook1.yml"
      end

      box.vm.provision "shell", path: "./step1.sh"

      box.vm.provision "nginx", type: "ansible" do |ansible|
        ansible.compatibility_mode = "2.0"
        ansible.playbook = "playbook2.yml"
      end
      box.vm.provision "shell", path: "./step2.sh"

    end
  end
end