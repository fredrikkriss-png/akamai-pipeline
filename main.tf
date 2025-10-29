# Optional helpers to discover IDs you’ll need (uncomment one approach)

# Approach A: Look up by group name
# data "akamai_contract" "this" {
#   group_name = var.group_name
# }
# data "akamai_group" "this" {
#   name        = var.group_name
#   contract_id = data.akamai_contract.this.contract_id
# }

# Approach B: Provide IDs directly via variables
locals {
  contract_id = coalesce(var.contract_id, "") # e.g., "C-XXXX"
  group_id    = coalesce(var.group_id,    "") # e.g., "12345"
}

variable "contract_id" { type = string, default = null }
variable "group_id"    { type = string, default = null }
variable "group_name"  { type = string, default = null } # only if using Approach A
variable "hostnames"   { type = list(string) }

# (Optional) See what hostnames are selectable for this contract/group
# data "akamai_appsec_selectable_hostnames" "available" {
#   contract_id = local.contract_id != "" ? local.contract_id : data.akamai_contract.this.contract_id
#   group_id    = local.group_id    != "" ? local.group_id    : data.akamai_group.this.id
# }
# output "selectable_hostnames" {
#   value = try(data.akamai_appsec_selectable_hostnames.available.hostnames, [])
# }

resource "akamai_appsec_configuration" "connectivity_test" {
  name        = "Connectivity Test Config"
  description = "Created by Terraform via GitHub Actions"
  contract_id = local.contract_id # or: data.akamai_contract.this.contract_id
  group_id    = local.group_id    # or: data.akamai_group.this.id
  host_names  = var.hostnames     # must include at least one selectable hostname
}
