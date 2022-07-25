#kube-proxy-v1.22.6-eksbuild.1",adot -v0.51.0-eksbuild.1,vpc-cni - v1.11.2-eksbuild.1",coredns -v1.8.7-eksbuild.1,aws-ebs-csi-driver- v1.8.0-eksbuild.0

variable "eks_addons" {
  type = list(object({
    addon_name    = string
    addon_version = string
  }))
}
variable "cluster_name" {
    description      = "(Required) Name of the EKS Cluster."
    type             = string
    default          = ""
}

variable "resolve_conflicts" {
    description      = "(Optional) Define how to resolve parameter value conflicts when migrating an existing add-on to an Amazon EKS add-on or when applying version updates to the add-on. Valid values are NONE and OVERWRITE."
    type             = string
    default          = "OVERWRITE"
}
/* variable "service_account_role_arn" {
    description      = "(Optional) The Amazon Resource Name (ARN) of an existing IAM role to bind to the add-on's service account."
    type             = string
    default          = ""
} */

