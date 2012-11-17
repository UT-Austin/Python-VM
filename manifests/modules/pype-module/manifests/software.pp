class software {
    $local_installer_path = "${pype_dir}/pype_installer.py"

    package {$pype::pype_requirements:
        ensure => latest,
        require => Exec['apt_update'],
    }

    file {$pype::flag_dir:
        ensure => 'directory',
        owner => 'vagrant',
    }

    file {'/vagrant':
        ensure => 'directory',
        owner => 'vagrant',
    }

    file {'/vagrant/pype':
        ensure => 'directory',
        require => File['/vagrant'],
        owner => 'vagrant',
    }

    file {$pype_dir:
        ensure => 'link',
        require => File['/vagrant/pype'],
        target => '/vagrant/pype',
        owner => 'vagrant',
        mode => 0755,
    }

    exec {'get_pype_installer':
        cwd => $pype_dir,
        command => "wget ${installer_url} --output-document=${local_installer_path}",
        require => File[$pype_dir],
        unless => "test -f ${local_installer_path}",
    }

    exec {'install_pype_tools':
        cwd => $pype_dir,
        # This is super obtuse, but will pick the right tools version
        command => "yes bad | python ${local_installer_path} install | grep -e ') ${pype_tools_version}$' | sed 's/^\\s\\+\\([0-9]\\+\\)).*$/\\1/' | sudo python ${local_installer_path} install ${pype_install_options}",
        require => [Package[$pype::pype_requirements],
                    Exec['get_pype_installer']],
        timeout => 0,
    }

    exec {'autopype':
        cwd => '/home/vagrant',
        command => "echo \"source `ls ${pype_dir}/activate* | tail -1` && cd /pype\" >> .bashrc && touch ${pype::flag_dir}/autopype",
        require => [Exec['install_pype_tools'],
                    File[$pype::flag_dir]],
        creates => "${pype::flag_dir}/autopype",
    }

    exec {'setup_stunnel':
        # TODO: build a valid stunnel.conf file from the default combined with the UT one
        command => 'echo',
        require => Package[$pype::pype_requirements],
    }
}
