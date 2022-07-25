
variable "cluster_name" {
  description = "(Required) Name of the cluster"
  type        = string
  default     = ""
}

variable "pod_execution_role_arn" {
  description = "(Required) Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Fargate Profile"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "(Required) Identifiers of private EC2 Subnets to associate with the EKS Fargate Profile."
  type        = list
  default     = []
}
variable "fargate_profile" {
  type = list(object({
    fargate_profile_name    = string
    namespace               = string
  }))
}
variable "enable_fargate" {
  type        = bool
  default     = false
}