# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define "zoo1" do |zoo1|
    zoo1.vm.box = "ubuntu/trusty64"
    zoo1.vm.network "private_network", ip: "172.28.128.9"
    zoo1.vm.provision :shell do |s|
      s.path = 'provision.sh'
    end
    zoo1.vm.synced_folder "zookeeper_home", "/home/bodl-tei-svc", mount_options: ["uid=1010,gid=1010"]
  end

  config.vm.define "solr1" do |solr1|
    solr1.vm.box = "ubuntu/trusty64"
    solr1.vm.network "private_network", ip: "172.28.128.10"
    solr1.vm.provision :shell do |s|
      s.path = 'provision.sh'
    end
    solr1.vm.synced_folder "solr1_home", "/home/bodl-tei-svc", mount_options: ["uid=1010,gid=1010"]
    solr1.vm.network "forwarded_port", guest: 8983, host: 8983
  end

  config.vm.define "solr2" do |solr2|
    solr2.vm.box = "ubuntu/trusty64"
    solr2.vm.network "private_network", ip: "172.28.128.11"
    solr2.vm.provision :shell do |s|
      s.path = 'provision.sh'
    end
    solr2.vm.synced_folder "solr2_home", "/home/bodl-tei-svc", mount_options: ["uid=1010,gid=1010"]
    solr2.vm.network "forwarded_port", guest: 8983, host: 8984
  end

  config.vm.define "blacklight" do |blacklight|
    blacklight.vm.box = "ubuntu/trusty64"
    blacklight.vm.network "private_network", ip: "172.28.128.12"
    blacklight.vm.provision :shell do |s|
      s.path = 'provision.sh'
    end
    blacklight.vm.synced_folder "blacklight_home", "/home/bodl-tei-svc/sites/bodl-tei-svc/parts/", mount_options: ["uid=1010,gid=1010"]
    blacklight.vm.network "forwarded_port", guest: 3000, host: 3000
    blacklight.vm.network "forwarded_port", guest: 8080, host: 8080
  end

end
