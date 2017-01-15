# vim: set expandtab:
define l2mesh::host(
  $host,
  $ip,
  $port,
  $tcp_only,
  $public_key,
  $tag_conf,
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
    content => "Address = ${ip}
Port = ${port}
Compression = 0
TCPOnly = ${tcp_only}

${public_key}
",

  }
  concat::fragment { "${tag_conf}_${fqdn}":
    target  => $conf,
    tag     => "${tag_conf}_${fqdn}",
    content => "ConnectTO = ${fqdn}\n",
  }
}
