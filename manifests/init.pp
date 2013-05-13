class nodejs($user) {

  case $operatingsystemrelease {
    "11.04": {
      $repository="deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu natty main"
    }
    "11.10": {
      $repository="deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu oneiric main"
    }
    "12.04": {
      $repository="deb http://ppa.launchpad.net/chris-lea/node.js/ubuntu precise main"
    }
  }

  package { "build-essential":
    ensure => latest
  }

  package { "python-software-properties":
    ensure => latest
  }

  exec { "chris-lea-apt-repo":
    path => "/bin:/usr/bin",
    command => "echo '${repository}' >> /etc/apt/sources.list",
    unless => "cat /etc/apt/sources.list | grep chris-lea",
    require => Package["python-software-properties"],
  }
  
  exec { "chris-lea-apt-key":
    path => "/bin:/usr/bin",
    command => "apt-key adv --keyserver keyserver.ubuntu.com --recv C7917B12",
    unless => "apt-key list | grep chris-lea",
    require => Exec["chris-lea-apt-repo"],
  }
  
  exec { "update-apt":
    path => "/bin:/usr/bin",
    command => "apt-get update",
    unless => "ls /usr/bin | grep node",
    require => Exec["chris-lea-apt-key"],
  }

  package { 'nodejs': 
      ensure  => installed
    , require => [Exec['update-apt']]
  }
  
}

