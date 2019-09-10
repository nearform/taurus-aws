variable "route53_hosted_zone" {}
variable "domain_name" {}
variable "tags" {
  default = {}
}
variable "waf_id" {
  default = null
}