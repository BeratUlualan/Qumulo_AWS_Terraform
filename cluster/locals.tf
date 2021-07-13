locals {
  digits     = split(".", "${var.floating_ips}")
  last_digit = split("-", local.digits[3])
  range_list = range(local.last_digit[0], local.last_digit[1] + 1)

  floating_ip = [
    for i in local.range_list : [
      join(".", [local.digits[0], local.digits[1], local.digits[2], i])
    ]
  ]

  floating_ip_list = flatten(local.floating_ip)

}
