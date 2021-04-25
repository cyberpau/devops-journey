CPUS="1"
MEMORY="1024"

Vagrant.configure("2") do |config|

  config.vm.box = "centos/7"
  config.vm.hostname = "master.puppet.vm"

  config.vm.provider "virtualbox" do |v|
    v.name = "master.puppet.vm"
    v.memory = MEMORY
    v.cpus = CPUS
  end

end
