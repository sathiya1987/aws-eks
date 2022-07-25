locals{
  #EKS_Node_group  
  node                         = { for node_group in var.eks_node_group : node_group["node_group_name"] => {
    subnet_ids                 = node_group["subnet_ids"]
    ami_type                   = node_group["ami_type"]
    capacity_type              = node_group["capacity_type"]
    disk_size                  = node_group["disk_size"]
    instance_types             = node_group["instance_types"]
    k8_version                    = node_group["k8_version"] 
    cluster_name               = node_group["cluster_name"]
    force_update_version       = node_group["force_update_version"] 
    labels                     = node_group["labels"]
    node_group_name            = node_group["node_group_name"]
    taints                     = node_group["taints"]
    ec2_ssh_key                = node_group["ec2_ssh_key"]
    source_security_group_ids  = node_group["source_security_group_ids"]
    desired_size               = node_group["desired_size"]
    max_size                   = node_group["max_size"]
    min_size                   = node_group["min_size"]
    max_unavailable            = node_group["max_unavailable"]
  #  max_unavailable_percentage = node_group["max_unavailable_percentage"]
    }

}
###UserData 
int_linux_default_user_data = var.create && var.platform == "linux" && (var.enable_bootstrap_user_data || var.user_data_template_path != "") ? base64encode(templatefile(
    coalesce(var.user_data_template_path, "${path.module}/../../templates/linux_user_data.tpl"),
    {
      # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
      enable_bootstrap_user_data = var.enable_bootstrap_user_data
      # Required to bootstrap node
      cluster_name        = var.cluster_name
      cluster_endpoint    = var.cluster_endpoint
      cluster_auth_base64 = var.cluster_auth_base64
      # Optional
      cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr != null ? var.cluster_service_ipv4_cidr : ""
      bootstrap_extra_args      = var.bootstrap_extra_args
      pre_bootstrap_user_data   = var.pre_bootstrap_user_data
      post_bootstrap_user_data  = var.post_bootstrap_user_data
    }
  )) : ""
  platform = {
    bottlerocket = {
      user_data = var.create && var.platform == "bottlerocket" && (var.enable_bootstrap_user_data || var.user_data_template_path != "" || var.bootstrap_extra_args != "") ? base64encode(templatefile(
        coalesce(var.user_data_template_path, "${path.module}/../../templates/bottlerocket_user_data.tpl"),
        {
          # https://docs.aws.amazon.com/eks/latest/userguide/launch-templates.html#launch-template-custom-ami
          enable_bootstrap_user_data = var.enable_bootstrap_user_data
          # Required to bootstrap node
          cluster_name        = var.cluster_name
          cluster_endpoint    = var.cluster_endpoint
          cluster_auth_base64 = var.cluster_auth_base64
          # Optional - is appended if using EKS managed node group without custom AMI
          # cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr # Bottlerocket pulls this automatically https://github.com/bottlerocket-os/bottlerocket/issues/1866
          bootstrap_extra_args = var.bootstrap_extra_args
        }
      )) : ""
    }
    linux = {
      user_data = try(data.cloudinit_config.linux_eks_managed_node_group[0].rendered, local.int_linux_default_user_data)

    }
    windows = {
      user_data = var.create && var.platform == "windows" && var.enable_bootstrap_user_data ? base64encode(templatefile(
        coalesce(var.user_data_template_path, "${path.module}/../../templates/windows_user_data.tpl"),
        {
          # Required to bootstrap node
          cluster_name        = var.cluster_name
          cluster_endpoint    = var.cluster_endpoint
          cluster_auth_base64 = var.cluster_auth_base64
          # Optional - is appended if using EKS managed node group without custom AMI
          # cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr # Not supported yet: https://github.com/awslabs/amazon-eks-ami/issues/805
          bootstrap_extra_args     = var.bootstrap_extra_args
          pre_bootstrap_user_data  = var.pre_bootstrap_user_data
          post_bootstrap_user_data = var.post_bootstrap_user_data
        }
      )) : ""
    }
  }

# There are 4 scenarios here that have to be considered for `use_custom_launch_template`:
  # 1. `var.create_launch_template = false && var.launch_template_name == ""` => EKS MNG will use its own default LT
  # 2. `var.create_launch_template = false && var.launch_template_name == "something"` => User provided custom LT will be used
  # 3. `var.create_launch_template = true && var.launch_template_name == ""` => Custom LT will be used, module will provide a default name
  # 4. `var.create_launch_template = true && var.launch_template_name == "something"` => Custom LT will be used, LT name is provided by user
  use_custom_launch_template = var.create_launch_template || var.launch_template_name != ""

  launch_template_name_int = coalesce(var.launch_template_name, "${"eks"}-eks-node-group")

  security_group_ids = compact(concat([try(aws_security_group.this[0].id, ""), var.cluster_primary_security_group_id], var.vpc_security_group_ids))
  launch_template_name = try(aws_launch_template.this[0].name, var.launch_template_name, null)
  # Change order to allow users to set version priority before using defaults
  launch_template_version = coalesce(var.launch_template_version, try(aws_launch_template.this[0].default_version, "$Default"))

###IAM 
  iam_role_name = coalesce(var.iam_role_name, "${"eks"}-eks-node-group")

  iam_role_policy_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  cni_policy = var.cluster_ip_family == "ipv6" ? "arn:${data.aws_partition.current.partition}:iam::${data.aws_caller_identity.current.account_id}:policy/AmazonEKS_CNI_IPv6_Policy" : "${local.iam_role_policy_prefix}/AmazonEKS_CNI_Policy"
 #Security Group
  security_group_name   = coalesce(var.security_group_name, "${"eks"}-eks-node-group")
  create_security_group = var.create && var.create_security_group
}

  