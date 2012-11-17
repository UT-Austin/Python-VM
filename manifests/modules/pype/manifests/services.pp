# == Class: services
#
# Provision services for pype
#
class pype::services {
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

    $cb_jar = "${::pype_dir}/${::pype_tools_version}/clientbroker-*.jar"
    $jarfile = "`ls ${cb_jar} | tail -1`"
    $jarcmd = "java -jar ${jarfile}"
    exec {'clientbroker':
        # TODO change to service
        environment => ['DISPLAY="localhost:8001.0"'],
        command     => $jarcmd,
        unless      => 'pgrep clientbroker',
        require     => [Exec['install_pype_tools'],
                    Exec['vncserver']],
    }
}
