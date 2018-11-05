# vim: set expandtab:
define l2mesh::host(
  $host,
  $tcp_only,
  $public_key,
  $tag_conf,
  $ip = undef,
  $port = undef,
  $fqdn = $name,
  $conf = undef,
) {

  file { $host:
    owner   => root,
    group   => root,
    mode    => '0444',
    require => File[$hosts],
    notify  => Exec[$reload],
    before  => Service[$service],
    tag     => $tag,
    content => template('l2mesh/host.erb'),

  }
  if $ip {
    concat::fragment { "${tag_conf}_${fqdn}":
      target  => $conf,
      tag     => "${tag_conf}_${fqdn}",
      content => "ConnectTO = ${fqdn}\n",
    }
  }
}
