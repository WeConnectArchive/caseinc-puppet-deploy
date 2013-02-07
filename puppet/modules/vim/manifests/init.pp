class vim{

        package { "vim":
                ensure => present,
        }

        exec { "update-alternatives --set editor /usr/bin/vim.basic":
                path => "/bin:/sbin:/usr/bin:/usr/sbin",
                unless => "test /etc/alternatives/editor -ef /usr/bin/vim.basic"
        }

        file { "/etc/vim/vimrc" :
          require => Package["vim"],
          ensure  => "present",
          owner   => root,
          mode    => 644,
          content => "puppet:///modules/vim/vimrc"
        }

}
