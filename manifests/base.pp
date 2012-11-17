File {
    owner => 0,
    group => 0,
    mode => 0644,
}

Exec {
    path => [
        '/usr/local/sbin',
        '/usr/local/bin',
        '/usr/sbin',
        '/usr/bin',
        '/sbin',
        '/bin',
        '/opt/vagrant_ruby/bin',
    ]
}

Service {
    path => [
        '/etc/init.d',
    ]
}

group {'puppet':
    ensure => 'present',
}

file {'/etc/motd':
    content => 'Ceci n\'est pas une PyPE.',
}

exec {'apt_update':
    command => '/usr/bin/sudo /usr/bin/apt-get update',
}

exec {'apt_upgrade':
    command => '/usr/bin/sudo /usr/bin/apt-get upgrade -y',
    require => Exec['apt_update'],
    timeout => 0,
}

class {'pype': }
