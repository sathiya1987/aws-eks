
variable "cluster_name" {
  description = "(Required) Name of the EKS cluster"
  type        = string
  default     = ""
}
variable "client_id" {
  description = "(Required) Client ID for the OpenID Connect identity provider."
  type        = string
  default     = ""
}
variable "groups_claim" {
  description = "(Optional) The JWT claim that the provider will use to return groups."
  type        = string
  default     = ""
}
variable "groups_prefix" {
  description = "(Optional) A prefix that is prepended to group claims e.g., oidc."
  type        = string
  default     = ""
}
variable "identity_provider_config_name" {
  description = "(Required) The name of the identity provider config."
  type        = string
  default     = ""
}
variable "issuer_url" {
  description = "(Required) The name of the identity provider config."
  type        = string
  default     = ""
}
variable "required_claims" {
  description = "(Optional) The key value pairs that describe required claims in the identity token."
  type        = map(string)
  default     = {}
}
variable "username_claim" {
  description = "(Optional) The JWT claim that the provider will use as the username."
  type        = string
  default     = ""
}
variable "username_prefix" {
  description = "(Optional) A prefix that is prepended to username claims."
  type        = string
  default     = ""
}
variable "enable_oidc" {
  description = "To manage oidc."
  type        = bool
  default     = false
}