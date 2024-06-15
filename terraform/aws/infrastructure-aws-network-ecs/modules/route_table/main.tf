resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  tags = {
    Name        = var.route_table_name == "default" ? "${var.name}-${var.env}-route-table-${var.is_public ? "public" : "private"}" : var.route_table_name
    Environment = "${var.env}"
  }
}

resource "aws_route_table_association" "subnets" {
  count = length(var.subnet_ids)

  route_table_id = aws_route_table.route_table.id
  subnet_id      = var.subnet_ids[count.index]
}

locals {
  gateways = flatten([
    for gateway in var.gateways : [
      {
        id    = "${split(":", "${gateway}")[1]}"
        value = split(":", "${gateway}")[0]
      }
    ]
  ])
}

resource "aws_route" "ipv4_route" {
  for_each               = var.routes
  route_table_id         = aws_route_table.route_table.id
  destination_cidr_block = each.value.route[0]

  carrier_gateway_id        = each.value.route[1] == "carrier_gw" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  core_network_arn          = each.value.route[1] == "core_network_arn" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  egress_only_gateway_id    = each.value.route[1] == "egress_only_gw" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  gateway_id                = each.value.route[1] == "internet_gw" || each.value.route[1] == "vgw" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  local_gateway_id          = each.value.route[1] == "local_gw" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  nat_gateway_id            = each.value.route[1] == "nat_gw" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  network_interface_id      = each.value.route[1] == "network_interface" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  transit_gateway_id        = each.value.route[1] == "transit_gw" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  vpc_endpoint_id           = each.value.route[1] == "vpc_endpoint" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  vpc_peering_connection_id = each.value.route[1] == "vpc_peering_connection" ? try(lookup({ for gateway in local.gateways : "${gateway.id}" => gateway }, "${each.value.route[1]}").value, null) : null
  depends_on = [
    aws_route_table.route_table
  ]
}