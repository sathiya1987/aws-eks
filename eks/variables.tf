
variable "cluster_name" {
  description = "(Required) Name of the cluster"
  type        = string
  default     = ""
}

variable "create" {
  description = "Controls if EKS resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}
variable "eks_cluster_role_arn" {
  description = "(Required) ARN of the IAM role"
  type        = string
  default     = ""
}
variable "eks_cluster_version" {
  description = "(Optional) Desired Kubernetes master version."
  type        = string
  default     = "1.22"
}

variable "enabled_cluster_log_types" {
  description = "(Optional) List of the desired control plane logging to enable.Valid values are api,audit,authenticator,controllerManager,scheduler"
  type        = list
  default     = ["api","audit","authenticator","controllerManager","scheduler"]
}

variable "eks_cluster_subnets" {
  description = "(Optional) The IPv6 network range for the subnet, in CIDR notation"
  type        = list
  default     = []
}

variable "endpoint_private_access" {
  description = "(Optional) Whether the Amazon EKS private API server endpoint is enabled. Default is false."
  type        = string
  default     = "true"
}
variable "endpoint_public_access" {
  description = "(Optional) Whether the Amazon EKS public API server endpoint is enabled. Default is true."
  type        = string
  default     = "false"
}
variable "public_access_cidrs" {
  description = "(Optional) List of CIDR blocks. Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. EKS defaults this to a list with 0.0.0.0/0."
  type        = list
  default     = []
}  

/* variable "security_group_ids" {
  description = "(Optional) List of security group IDs for the cross-account elastic network interfaces that Amazon EKS"
  type        = list
  default     = []
}  */
variable "service_ipv4_cidr" {
  description = "(Optional) The CIDR block to assign Kubernetes service IP addresses from. 10.100.0.0/16"
  type        = string
  default     = "10.100.0.0/16"
}  
variable "ip_family" {
  description = "(Optional) The IP family used to assign Kubernetes pod and service addresses. Valid values are ipv4 and ipv6"
  type        = string
  default     = "ipv4"
} 

variable "vpc_id" {
    type =string
    default = ""
}

variable "kms_key_arn" {
    type =string
    default = ""
}
variable "eks_addons" {
  type = list(object({
    addon_name    = string
    addon_version = string
  }))

  default = []
}

variable "fargate_profile" {
  type = list(object({
    fargate_profile_name    = string
    namespace               = string
  }))
  default = [
    {
      fargate_profile_name    = "test-fargate"
      namespace               = "demo"
    },
    {
      fargate_profile_name    = "test-fargate1"
      namespace               = "demo1"
    }
    ]
}

##---------------------------EKS NODE GROUP PROPERTIES--------------------------

variable "node_role_arn" {
  description = "(Required) Amazon Resource Name (ARN) of the IAM Role that provides permissions for the EKS Node Group."
  type        = string
  default     = ""
}
 variable "ami_release_version" {
  description = "(Optional) AMI version of the EKS Node Group."
  type        = string
  default     = "1.22.9-20220629"
} 
variable "eks_node_group" {
  type = list(object({
    subnet_ids                 = list(string)
    ami_type                   = string 
    capacity_type              = string
    disk_size                  = number
    instance_types             = list(string)
    k8_version                 = string
    cluster_name               = string
    force_update_version       = bool
    labels                     = map(string)
    node_group_name            = string
    taints                     = list(any)
    ec2_ssh_key                = string 
    source_security_group_ids  = list(string)
    desired_size               = number
    max_size                   = number
    min_size                   = number
    max_unavailable            = number
  #  max_unavailable_percentage = number
                 
  }))

  default = []  
  
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}
###############################################################################
# Launch template
################################################################################

variable "create_launch_template" {
  description = "Determines whether to create a launch template or not. If set to `false`, EKS will use its own default launch template"
  type        = bool
  default     = false
}

variable "launch_template_version" {
  description = "Launch template version number. The default is `$Default`"
  type        = string
  default     = ""
}

variable "launch_template_name" {
  description = "Launch template name - either to be created (`var.create_launch_template` = `true`) or existing (`var.create_launch_template` = `false`)"
  type        = string
  default     = ""
}

variable "launch_template_use_name_prefix" {
  description = "Determines whether to use `launch_template_name` as is or create a unique name beginning with the `launch_template_name` as the prefix"
  type        = bool
  default     = true
}

variable "launch_template_description" {
  description = "Description of the launch template"
  type        = string
  default     = null
}

variable "ebs_optimized" {
  description = "If true, the launched EC2 instance(s) will be EBS-optimized"
  type        = bool
  default     = null
}

variable "ami_id" {
  description = "The AMI from which to launch the instance. If not supplied, EKS will use its own default image"
  type        = string
  default     = ""
}
variable "key_name" {
  description = "The key name that should be used for the instance(s)"
  type        = string
  default     = ""
}
variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate"
  type        = list(string)
  default     = []
}

variable "cluster_primary_security_group_id" {
  description = "The ID of the EKS cluster primary security group to associate with the instance(s). This is the security group that is automatically created by the EKS service"
  type        = string
  default     = null
}

variable "launch_template_default_version" {
  description = "Default version of the launch template"
  type        = string
  default     = null
}

variable "update_launch_template_default_version" {
  description = "Whether to update the launch templates default version on each update. Conflicts with `launch_template_default_version`"
  type        = bool
  default     = true
}

variable "disable_api_termination" {
  description = "If true, enables EC2 instance termination protection"
  type        = bool
  default     = null
}

variable "kernel_id" {
  description = "The kernel ID"
  type        = string
  default     = null
}

variable "ram_disk_id" {
  description = "The ID of the ram disk"
  type        = string
  default     = null
}

variable "block_device_mappings" {
  description = "Specify volumes to attach to the instance besides the volumes specified by the AMI"
  type        = any
  default     = {}
}

variable "capacity_reservation_specification" {
  description = "Targeting for EC2 capacity reservations"
  type        = any
  default     = {}
}

variable "cpu_options" {
  description = "The CPU options for the instance"
  type        = map(string)
  default     = {}
}

variable "credit_specification" {
  description = "Customize the credit specification of the instance"
  type        = map(string)
  default     = {}
}

variable "elastic_gpu_specifications" {
  description = "The elastic GPU to attach to the instance"
  type        = map(string)
  default     = {}
}

variable "elastic_inference_accelerator" {
  description = "Configuration block containing an Elastic Inference Accelerator to attach to the instance"
  type        = map(string)
  default     = {}
}

variable "enclave_options" {
  description = "Enable Nitro Enclaves on launched instances"
  type        = map(string)
  default     = {}
}

variable "instance_market_options" {
  description = "The market (purchasing) option for the instance"
  type        = any
  default     = {}
}

variable "license_specifications" {
  description = "A list of license specifications to associate with"
  type        = map(string)
  default     = {}
}

variable "metadata_options" {
  description = "Customize the metadata options for the instance"
  type        = map(string)
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
  }
}

variable "enable_monitoring" {
  description = "Enables/disables detailed monitoring"
  type        = bool
  default     = true
}

variable "network_interfaces" {
  description = "Customize network interfaces to be attached at instance boot time"
  type        = list(any)
  default     = []
}

variable "placement" {
  description = "The placement of the instance"
  type        = map(string)
  default     = {}
}

variable "launch_template_tags" {
  description = "A map of additional tags to add to the tag_specifications of launch template created"
  type        = map(string)
  default     = {}
}

################################################################################
# Security Group
################################################################################

variable "create_security_group" {
  description = "Determines whether to create a security group"
  type        = bool
  default     = true
}

variable "security_group_name" {
  description = "Name to use on security group created"
  type        = string
  default     = null
}

variable "security_group_use_name_prefix" {
  description = "Determines whether the security group name (`security_group_name`) is used as a prefix"
  type        = string
  default     = true
}

variable "security_group_description" {
  description = "Description for the security group created"
  type        = string
  default     = "EKS managed node group security group"
}

variable "security_group_rules" {
  description = "List of security group rules to add to the security group created"
  type        = any
  default     = {}
}

variable "cluster_security_group_id" {
  description = "Cluster control plane security group ID"
  type        = string
  default     = null
}

variable "security_group_tags" {
  description = "A map of additional tags to add to the security group created"
  type        = map(string)
  default     = {}
}

 #IAM Role
################################################################################

variable "create_iam_role" {
  description = "Determines whether an IAM role is created or to use an existing IAM role"
  type        = bool
  default     = false
}

variable "cluster_ip_family" {
  description = "The IP family used to assign Kubernetes pod and service addresses. Valid values are `ipv4` (default) and `ipv6`"
  type        = string
  default     = null
}

variable "iam_role_arn" {
  description = "Existing IAM role ARN for the node group. Required if `create_iam_role` is set to `false`"
  type        = string
  default     = null
}

variable "iam_role_name" {
  description = "Name to use on IAM role created"
  type        = string
  default     = null
}

variable "iam_role_use_name_prefix" {
  description = "Determines whether the IAM role name (`iam_role_name`) is used as a prefix"
  type        = bool
  default     = true
}

variable "iam_role_path" {
  description = "IAM role path"
  type        = string
  default     = null
}

variable "iam_role_description" {
  description = "Description of the role"
  type        = string
  default     = null
}

variable "iam_role_permissions_boundary" {
  description = "ARN of the policy that is used to set the permissions boundary for the IAM role"
  type        = string
  default     = null
}

variable "iam_role_attach_cni_policy" {
  description = "Whether to attach the `AmazonEKS_CNI_Policy`/`AmazonEKS_CNI_IPv6_Policy` IAM policy to the IAM IAM role. WARNING: If set `false` the permissions must be assigned to the `aws-node` DaemonSet pods via another method or nodes will not be able to join the cluster"
  type        = bool
  default     = false
}

variable "iam_role_additional_policies" {
  description = "Additional policies to be added to the IAM role"
  type        = list(string)
  default     = []
}

variable "iam_role_tags" {
  description = "A map of additional tags to add to the IAM role created"
  type        = map(string)
  default     = {}
}

#User Data
variable "platform" {
  description = "Identifies if the OS platform is `bottlerocket`, `linux`, or `windows` based"
  type        = string
  default     = "linux"
}

variable "enable_bootstrap_user_data" {
  description = "Determines whether the bootstrap configurations are populated within the user data template"
  type        = bool
  default     = false
}

variable "is_eks_managed_node_group" {
  description = "Determines whether the user data is used on nodes in an EKS managed node group. Used to determine if user data will be appended or not"
  type        = bool
  default     = true
}


variable "cluster_endpoint" {
  description = "Endpoint of associated EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_auth_base64" {
  description = "Base64 encoded CA of associated EKS cluster"
  type        = string
  default     = ""
}

variable "cluster_service_ipv4_cidr" {
  description = "The CIDR block to assign Kubernetes service IP addresses from. If you don't specify a block, Kubernetes assigns addresses from either the 10.100.0.0/16 or 172.20.0.0/16 CIDR blocks"
  type        = string
  default     = null
}

variable "pre_bootstrap_user_data" {
  description = "User data that is injected into the user data script ahead of the EKS bootstrap script. Not used when `platform` = `bottlerocket`"
  type        = string
  default     = ""
}

variable "post_bootstrap_user_data" {
  description = "User data that is appended to the user data script after of the EKS bootstrap script. Not used when `platform` = `bottlerocket`"
  type        = string
  default     = ""
}

variable "bootstrap_extra_args" {
  description = "Additional arguments passed to the bootstrap script. When `platform` = `bottlerocket`; these are additional [settings](https://github.com/bottlerocket-os/bottlerocket#settings) that are provided to the Bottlerocket user data"
  type        = string
  default     = ""
}

variable "user_data_template_path" {
  description = "Path to a local, custom user data template file to use when rendering user data"
  type        = string
  default     = ""
}

#---------OIDC-----------

variable "enable_oidc" {
  description = "To control to create OIDC for EKS cluster"
  type        = bool
  default     = false
}

#-----------FARGATE-------------------

variable "enable_fargate" {
  description = "To control to create Fargate for EKS cluster"
  type        = bool
  default     = false
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

