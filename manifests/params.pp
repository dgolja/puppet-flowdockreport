class flowdockreport::params {
  $package_name = 'flowdock'

  if str2bool($::is_pe) {
    $puppetconf_path = '/etc/puppetlabs/puppet'
    $provider        = 'pe_gem'
    $owner           = 'pe-puppet'
    $group           = 'pe-puppet'
  } else {
    $puppetconf_path = '/etc/puppet'
    $provider        = 'gem'
    $owner           = 'puppet'
    $group           = 'puppet'
  }
}