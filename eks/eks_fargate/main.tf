locals{
    fargate_eks              = {for fargate in var.fargate_profile : fargate.fargate_profile_name => fargate}  
}
resource "aws_eks_fargate_profile" "eks_fargate" {
  for_each               = var.enable_fargate ? local.fargate_eks : {}
  cluster_name           = var.cluster_name
  fargate_profile_name   = each.value["fargate_profile_name"]
  pod_execution_role_arn = var.pod_execution_role_arn
  subnet_ids             = var.subnet_ids
  selector {
    namespace            = each.value["namespace"]
  }
}