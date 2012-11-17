$extlookup_datadir = '/vagrant/manifests/extdata'
$extlookup_precedence = ['custom','defaults']
$pype_requirements = ['python2.6-dev',
                      'libsasl2-dev',
                      'libldap2-dev',
                      'libssl-dev',
                      'libxml2-dev',
                      'libxslt-dev',
                      'openjdk-6-jre',
                      'stunnel4',
                      #'openbox',
                      'vnc4server']
$flag_dir = '/home/vagrant/.flags'

$installer_url = extlookup('installer_url')
$pype_dir = extlookup('pype_dir')
$pype_install_options = extlookup('pype_install_options')
$pype_tools_version = extlookup('pype_tools_version')
$stunnel_cacert = extlookup('stunnel_cacert')
$stunnel_clientkeycert = extlookup('stunnel_clientkeycert')
$stunnel_conf = extlookup('stunnel_conf')

$local_installer_path = extlookup('local_installer_path', "${pype_dir}/pype_installer.py")

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

group {'puppet':
    ensure => 'present',
}

file {'/etc/motd':
    content => "Ceci n'est pas une PyPE.",
}

exec {'apt_update':
    command => "sudo apt-get update && sudo apt-get upgrade -y",
}

package {$pype_requirements:
    ensure => latest,
    require => Exec['apt_update'],
}

file {$flag_dir:
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
    unless => "stat ${local_installer_path}",
}

exec {'install_pype_tools':
    cwd => $pype_dir,
    # This is super obtuse, but will pick the right tools version
    command => "yes bad | python $local_installer_path install | grep -e ') ${pype_tools_version}$' | sed 's/^\\s\\+\\([0-9]\\+\\)).*$/\\1\\n/' | sudo python $local_installer_path $pype_install_options ",
    require => [Package[$pype_requirements],
                Exec['get_pype_installer']],
    unless => "stat ${pype_dir}/${pype_tools_version}",
    timeout => 0,
}

exec {'autopype':
    cwd => '/home/vagrant',
    command => "echo \"source $(ls $pype_dir/activate* | tail -1) && cd /pype\" >> .bashrc && touch ${flag_dir}/autopype",
    require => [Exec['install_pype_tools'],
                File[$flag_dir]],
    unless => 'stat ${flag_dir}/autopype',
}

exec {'setup_stunnel':
    # TODO: build a valid stunnel.conf file from the default combined with the UT one
    command => 'echo',
    require => Package[$pype_requirements],
}

service {'stunnel4':
    ensure => 'running',
    require => Exec['setup_stunnel'],
}

exec {'vncserver':
    command => 'yes vagrant | sudo vncserver :8001',
    unless => 'pgrep -f Xvnc4',
    require => Package[$pype_requirements],
}

#exec {'openbox':
#    environment => ['DISPLAY="localhost:8001"'],
#    require => Exec['vncserver'],
#}

exec {'clientbroker':
    environment => ['DISPLAY="localhost:8001"'],
    command => "java -jar $(ls ${pype_dir}/${pype_tools_version}/clientbroker-*.jar | tail -1)",
    unless => 'pgrep clientbroker',
    require => [Exec['install_pype_tools'],
                Exec['vncserver']],
}

notify {'pype_setup_complete':
    message => "Your PyPE environment is set up and running.",
    require => [Exec['install_pype_tools'],
                Service['stunnel4'],
                Exec['clientbroker']],
}
