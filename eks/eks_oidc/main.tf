resource "aws_eks_identity_provider_config" "eks_oidc" {
  count                                      = var.enable_oidc ? 1 : 0
  cluster_name                               = var.cluster_name
  oidc {
    client_id                                = var.client_id
    identity_provider_config_name            = var.identity_provider_config_name
    issuer_url                               = var.issuer_url
    groups_claim                             = var.groups_claim
    groups_prefix                            = var.groups_prefix
    required_claims                          = var.required_claims
    username_claim                           = var.username_claim
    username_prefix                          = var.username_prefix
  }
  tags ={
     Name                                   = "oidc" 
  }
}