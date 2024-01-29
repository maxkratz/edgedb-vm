token = ENV["GITHUB_TOKEN"]

Vagrant.configure("2") do |config|
    config.vm.box = "gusztavvargadr/xubuntu-desktop-2204-lts"
    config.vm.define 'edgedb'
    config.vm.provider :virtualbox do |vb|
        vb.name = "edgedb"
        vb.memory = 8192
        vb.cpus = 2
    end
    config.vm.provision "shell", path: "prov.sh", env: {"GITHUB_TOKEN" => token}, privileged: false

    # Prevent SharedFoldersEnableSymlinksCreate errors
    config.vm.synced_folder ".", "/vagrant", disabled: true
end
