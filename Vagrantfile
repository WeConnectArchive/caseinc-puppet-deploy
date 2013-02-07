Vagrant::Config.run do |config|

    config.vm.box = "squeeze64"
    config.vm.forward_port 80, 3306 
    config.vm.box_url = "http://andrew.mcnaughty.com/downloads/squeeze64_puppet27.box"

    # Required for serving puppet:/// using puppet standalone
    # http://java.dzone.com/articles/serving-files-puppet
    config.vm.share_folder "modules", "/etc/puppet/fileserver", "./puppet/modules"

    config.vm.provision  :puppet do |puppet|
        puppet.manifests_path = "puppet/manifests"
        puppet.manifest_file = "site.pp"
        puppet.module_path  = "puppet/modules"

        # Required for serving puppet:/// using puppet standalone
        # http://java.dzone.com/articles/serving-files-puppet
        # Snippet of <vagrant directory>/Vagrantfile
        puppet.options = ["--fileserverconfig=/vagrant/fileserver.conf"]
    end

end
