data "aws_partition" "current" {}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "assume_role_policy" {
  count = var.create && var.create_iam_role ? 1 : 0

  statement {
    sid     = "EKSNodeAssumeRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

data "cloudinit_config" "linux_eks_managed_node_group" {
  count = var.create && var.platform == "linux" && var.is_eks_managed_node_group && !var.enable_bootstrap_user_data && var.pre_bootstrap_user_data != "" && var.user_data_template_path == "" ? 1 : 0

  base64_encode = true
  gzip          = false
  boundary      = "//"

  # Prepend to existing user data suppled by AWS EKS
  part {
    content_type = "text/x-shellscript"
    content      = var.pre_bootstrap_user_data
  }
}