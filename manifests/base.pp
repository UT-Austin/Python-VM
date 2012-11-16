group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet.\n"
}

exec { "apt-get":
    command => "/usr/bin/apt-get update ; /usr/bin/apt-get upgrade -y",
}

$pype_requirements = ["python2.6-dev", "libsasl2-dev", "libldap2-dev", "libssl-dev", "libxml2-dev", "libxslt-dev"]
package {$pype_requirements:
    ensure  => latest,
    require => Exec['apt-get'],
}

file {'/home/trecs':
    ensure => "directory",
    owner => 'vagrant',
}

file { "/home/trecs/pype":
    ensure => "directory",
    require => File['/home/trecs'],
    owner => 'vagrant',
}

exec {'pype_installer_file':
    command => "/usr/bin/sudo /usr/bin/wget 'https://pype.its.utexas.edu/tools/install/bootstrap/latest/' --output-document=/home/trecs/pype/pype_installer.py",
    user => vagrant,
    require => File['/home/trecs/pype'],
}

# Choose the latest version of pype tools to install
exec {'pype_installer':
    cwd => '/home/trecs/pype',
    command => "/bin/echo 0 | /usr/bin/sudo /usr/bin/python pype_installer.py install",
    require => [Package[$pype_requirements], File['/home/trecs/pype'], Exec['pype_installer_file']],
    timeout => 0,
}

