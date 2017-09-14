class apache::mod::rpaf (
  $sethostname = true,
  $proxy_ips   = [ '127.0.0.1' ],
  $header      = 'X-Forwarded-For',
  $template    = 'apache/mod/rpaf.conf.erb',
  $setport     = true,
  $forbidifnotproxy = false,
  $sethttps    = true,
  $use_stderr_package = true # Compatibility with old/Debian rpaf module
) {
  include ::apache
  ::apache::mod { 'rpaf': }

  # There are multiple versions of the rpaf module, see:
  #    https://serverfault.com/questions/652279/apache-module-rpaf-documentation
  # The $use_stderr_package parameter is used to select the correct template
  # if set to 'false' it will use the newer 'gnif' package.
  # Old/Debian template for the 'stderr' package uses:
  # - $sethostname
  # - $proxy_ips
  # - $header
  # The newer gnif package also uses
  # - $setport
  # - $forbidifnotproxy
  # - $sethttps

  file { 'rpaf.conf':
    ensure  => file,
    path    => "${::apache::mod_dir}/rpaf.conf",
    mode    => $::apache::file_mode,
    content => template($template),
    require => Exec["mkdir ${::apache::mod_dir}"],
    before  => File[$::apache::mod_dir],
    notify  => Class['apache::service'],
  }
}
