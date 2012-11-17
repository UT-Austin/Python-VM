# == Class: pype
#
# Provision pype
#
class pype {
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

    class {'software': }
    class {'services': }

    notify {'pype_setup_complete':
        message => 'Your PyPE environment is set up and running.',
        require => [Exec['install_pype_tools'],
                    Service['stunnel4'],
                    Exec['clientbroker']],
    }
}
