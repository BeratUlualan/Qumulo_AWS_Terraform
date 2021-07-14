locals {
  digits1     = split(".", "${var.floating_ips}")
  last_digit1 = split("-", local.digits1[3])
  range_list1 = range(local.last_digit1[0], local.last_digit1[1] + 1)

  floating_ip = [
    for i in local.range_list1 : [
      join(".", [local.digits1[0], local.digits1[1], local.digits1[2], i])
    ]
  ]

  floating_ip_list = flatten(local.floating_ip)

}

locals {
  digits2     = split(".", "${var.persistent_ips}")
  last_digit2 = split("-", local.digits2[3])
  range_list2 = range(local.last_digit2[0], local.last_digit2[1] + 1)

  persistent_ip = [
    for i in local.range_list2 : [
      join(".", [local.digits2[0], local.digits2[1], local.digits2[2], i])
    ]
  ]

  persistent_ip_list = flatten(local.persistent_ip)

}
