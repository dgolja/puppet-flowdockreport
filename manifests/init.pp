class flowdockreport(
  $puppetconf_path    = $flowdockreport::params::puppetconf_path,
  $provider           = $flowdockreport::params::provider,
  $owner              = $flowdockreport::params::owner,
  $group              = $flowdockreport::params::group,
  $package_name       = $flowdockreport::params::package_name,
  $external_user_name = 'PuppetFlow',
  $flows              = {},
) inherits flowdockreport::params {

  file { "${puppetconf_path}/flowdock.yaml":
    ensure  => file,
    owner   => $owner,
    group   => $group,
    mode    => '0440',
    content => template('flowdockreport/flowdock.yaml.erb'),
  }

  package {$package_name:
    ensure   => present,
    provider => $provider,
  }

}