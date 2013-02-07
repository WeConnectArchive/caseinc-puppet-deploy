
# require sudo
package { 'sudo': ensure => present }

# extragroups  => If you need your user on custom extra groups (all users belong to a group with their name)
# publickey    => It expects a string with the public key inside, if empty public key is not created.
# privatekey   => It expects a string identifying a puppet source, if empty no private key is created.
# ssh_config   => It expects a path toa  file that will be used as source, if empty no ~/{user}/.ssh/config is created.
# uid          => It expects a int to be used as user uid, if empty puppet will let the system asign one (100X range)
# email        => User email for mailalias and git config
 
define define_user ($publickey = '', $privatekey = '', $extragroups = 'guru', $ssh_config = '', $uid = '', $email = '', $sudoer = true) {
		
    $user = $title

		user {
			$user :
				ensure => "present",
				managehome => true,
				groups => $extragroups,
				shell => "/bin/bash"
		}
		
    if $email {
      mailalias {
        "$user":
          ensure => present,
          recipient => "$email";
      }
    }

		if $uid != '' {
			User[$user] {
				uid => $uid
			}
		}

    if $sudoer {
      User[$user] {
        groups => [$extragroups, 'sudo']
			}
    }

    # SSH STUFF
		file {
			"/home/$user/.ssh" :
				require => User[$user],
				ensure => "directory",
				owner => $user,
				group => $user,
				mode => 700
		}

    # support for either string or file based keys
		if $publickey =~ /^puppet:/ {
			File["/home/${user}/.ssh/authorized_keys"] {
				source => $publickey
			}
		} else {
        File["/home/${user}/.ssh/authorized_keys"] {
				content => $publickey
			}
		}

		if $publickey {
			file {
				"/home/$user/.ssh/authorized_keys" :
					require => File["/home/$user/.ssh"],
					ensure => "present",
					owner => $user,
			  	group => $user,
					mode => 600,
			}
		}

		if $privatekey != '' {
			file {
				"/home/$user/.ssh/id_rsa" :
					require => File["/home/$user/.ssh"],
					ensure => "present",
					owner => $user,
				  group => $user,
					mode => 600,
					source => $privatekey
			}
		}

		if $ssh_config != '' {
			file {
				"/home/$user/.ssh/config" :
					require => File["/home/$user/.ssh"],
					ensure => "present",
					owner => $user,
          group => $user,
					mode => 600,
					source => $ssh_config
			}
		}

    # GIT STUFF
    file {
      "/home/$user/.gitconfig" :
				require => User[$user],
        ensure  => "present",
        owner   => $user,
        group   => $user,
        mode    => 600,
        content => template("users/gitconfig.erb") 
    }

    # BASH STUFF
    file {
      "/home/$user/.bashrc" :
        ensure => present,
        owner => $user,
        group => $user,
        mode => 600,
        content => "puppet:///modules/users/bashrc"
    }	

}

