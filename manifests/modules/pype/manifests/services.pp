class services {
    service {'stunnel4':
        ensure  => 'running',
        require => Exec['setup_stunnel'],
    }

    exec {'vncserver':
        # TODO change to service
        command => 'yes vagrant | sudo nohup vncserver :8001',
        unless  => 'pgrep -f Xvnc4',
        require => Package[$pype::pype_requirements],
    }

#exec {'openbox':
#    environment => ['DISPLAY="localhost:8001.0"'],
#    require => Exec['vncserver'],
#}

    exec {'clientbroker':
        # TODO change to service
        environment => ['DISPLAY="localhost:8001.0"'],
        command     => "java -jar `ls ${pype_dir}/${pype_tools_version}/clientbroker-*.jar | tail -1`",
        unless      => 'pgrep clientbroker',
        require     => [Exec['install_pype_tools'],
                    Exec['vncserver']],
    }
}
