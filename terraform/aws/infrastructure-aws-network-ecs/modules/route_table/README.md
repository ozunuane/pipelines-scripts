## About this Module
This terraform module creates and manages three resources:
* Route Table
* Route Table Association with Subnet and
* Routes

### Variables required to run this module include:
* env: The environment the above resources belong to. Used for tagging resources
* subnet_ids: list of subnets to associate the route table with
* vpc_id: The id of VPC in which the route table will be created
* service: The name of service the subnets belongs to, example include rds, ecs, glo, etc
* gateways: This is a list variable containing available gateways and gateway type. At least, one gateway must be provided to run this module. For example, to declare a nat gateway variable ["nat-12345f2e25f0ta:nat_gw"]. Valid gateways are nat_gw, carrier_gw, egress_only_gw, internet_gw, local_gw, network_interface, transit_gw, vpc_endpoint, and vpc_peering_connection. Once a gateway has been declared, it can be used once or multiple times as a route gateway.
* routes: This is a map variable. Each map key is a list variable containing a route destination and gateway (which is already declared)