class nodejs($version = '0.12') {

  package { "build-essential":
    ensure => latest
  }

  exec { "nodesource-ppa":
      path    => "/bin:/usr/bin"
    , command => "curl -L https://deb.nodesource.com/setup_${version} | bash -"
    , unless  => "test -f /etc/apt/sources.list.d/nodesource.list && cat /etc/apt/sources.list.d/nodesource.list | grep node_${version}"
  }

  package { 'nodejs': 
      ensure  => installed
    , require => Exec['nodesource-ppa']
  }
  
}