# -*- mode: ruby -*-
# vi: set ft=ruby :
# vi: set tabstop=2 shiftwidth=2 sts=2

vagrant_dir = File.expand_path(File.dirname(__FILE__))

Vagrant.configure("2") do |config|
  vagrant_version = Vagrant::VERSION.sub(/^v/, '')

  config.vm.provider :virtualbox do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  config.ssh.forward_agent = true

  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "vagrant"

  if defined? VagrantPlugins::HostsUpdater
    hosts_path = vagrant_dir + '/hosts'
    hosts = []

    file_hosts = IO.read(hosts_path).split( "\n" )
    file_hosts.each do |line|
      if line[0..0] != "#"
        hosts << line
      end
    end

    config.hostsupdater.aliases = hosts
  end

  config.vm.network :private_network, ip: "192.168.50.4"

  config.vm.synced_folder "config/", "/srv/config"
  config.vm.synced_folder "wordpress/", "/srv/wordpress/", :owner => "www-data", :mount_options => [ "dmode=775", "fmode=774" ]

  config.vm.provision :shell, :path => "provision.sh"

  config.vm.provision :shell, inline: "sudo service nginx restart", run: "always"
  config.vm.provision :shell, inline: "sudo service mysql restart", run: "always"

#  if defined? VagrantPlugins::Triggers
#    config.trigger.before :halt, :stdout => true do
#      run "vagrant ssh -c 'vagrant_halt'"
#    end
#    config.trigger.before :suspend, :stdout => true do
#      run "vagrant ssh -c 'vagrant_suspend'"
#    end
#    config.trigger.before :destroy, :stdout => true do
#      #run "vagrant ssh -c 'vagrant_destroy'"
#    end
#  end
end

