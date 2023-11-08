token = ENV["GITHUB_TOKEN"]

Vagrant.configure("2") do |config|
    config.vm.box = "gusztavvargadr/ubuntu-desktop-2004-lts-xfce"
    config.vm.define 'edgedb'
    config.vm.provider :virtualbox do |vb|
        vb.name = "edgedb"
        vb.memory = 4096
        vb.cpus = 1
    end
    config.vm.provision "shell", path: "prov.sh", env: {"GITHUB_TOKEN" => token}, privileged: false

    # Prevent SharedFoldersEnableSymlinksCreate errors
    config.vm.synced_folder ".", "/vagrant", disabled: true
end
