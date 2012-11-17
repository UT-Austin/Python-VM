# == Class: software
#
# Provision software for pype
#
class pype::software {
    $local_installer_path = "${::pype_dir}/pype_installer.py"

    package {$pype::pype_requirements:
        ensure  => latest,
        require => Exec['apt_upgrade'],
    }

    file {$pype::flag_dir:
        ensure => 'directory',
        owner  => 'vagrant',
    }

    file {'/vagrant':
        ensure => 'directory',
        owner  => 'vagrant',
    }

    file {'/vagrant/pype':
        ensure  => 'directory',
        require => File['/vagrant'],
        owner   => 'vagrant',
    }

    file {$::pype_dir:
        ensure  => 'link',
        require => File['/vagrant/pype'],
        target  => '/vagrant/pype',
        owner   => 'vagrant',
        mode    => '0755',
    }

    $wget_pype_options = "--output-document=${local_installer_path}"
    $wget_pype = "wget ${::installer_url} ${wget_pype_options}"
    exec {'get_pype_installer':
        cwd     => $::pype_dir,
        command => $wget_pype,
        require => File[$::pype_dir],
        unless  => "test -f ${local_installer_path}",
    }

    $run_pype_installer_base = "sudo python ${local_installer_path} install"
    $grep_pype_versions = "grep -e ') ${::pype_tools_version}$'"
    $sed_num = "sed 's/^\\s\\+\\([0-9]\\+\\)).*$/\\1/'"
    $get_pype_version_num = "yes bad | ${grep_pype_versions} | ${sed_num}"

    $run_pype_installer = "${run_pype_installer_base} ${::pype_install_options}"

    exec {'install_pype_tools':
        cwd     => $::pype_dir,
        command => "${get_pype_version_num} | ${run_pype_installer}",
        require => [Package[$pype::pype_requirements],
                    Exec['get_pype_installer']],
        timeout => 0,
    }

    $activate = "echo \"source `ls ${::pype_dir}/activate*"
    $mod_bash = "${activate} | tail -1` && cd /pype\" >> .bashrc"
    exec {'autopype':
        cwd     => '/home/vagrant',
        command => "${mod_bash} && touch ${pype::flag_dir}/autopype",
        require => [Exec['install_pype_tools'],
                    File[$pype::flag_dir]],
        creates => "${pype::flag_dir}/autopype",
    }

    exec {'setup_stunnel':
        # TODO: build a valid stunnel.conf combining default with UT
        command => 'echo',
        require => Package[$pype::pype_requirements],
    }
}
