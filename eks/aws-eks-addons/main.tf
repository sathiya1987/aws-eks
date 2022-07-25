resource "aws_eks_addon" "eks_addon" {
  for_each                                    = {for addon in var.eks_addons : addon.addon_name => addon}
  cluster_name                                = var.cluster_name
  addon_name                                  = each.value.addon_name
  addon_version                               = each.value.addon_version
  resolve_conflicts                           = var.resolve_conflicts
#  service_account_role_arn                    = var.service_account_role_arn
}
