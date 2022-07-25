resource "aws_eks_cluster" "eks_cluster" {
  count                                     = var.create ? 1 : 0
  name                                      = var.cluster_name
  role_arn                                  = var.eks_cluster_role_arn
  version                                   = var.eks_cluster_version
  vpc_config {
      subnet_ids                            = var.eks_cluster_subnets
      endpoint_private_access               = var.endpoint_private_access
      endpoint_public_access                = var.endpoint_public_access 
      public_access_cidrs                   = local.public_access_cidr
      security_group_ids                    = [aws_security_group.eks_cluster_sg[0].id]     
  }
  enabled_cluster_log_types                 = var.enabled_cluster_log_types 
  encryption_config {
      provider{
          key_arn                           = var.kms_key_arn         
      }
      resources                             = ["secrets"]
  }
  kubernetes_network_config {
      service_ipv4_cidr                     = var.service_ipv4_cidr
      ip_family                             = var.ip_family
  }
  tags = {

  }
   timeouts {
    create                                 = "30m"
    update                                 = "60m"
    delete                                 = "15m"
  }
}

resource "aws_security_group" "eks_cluster_sg" {
  count                                    = var.create ? 1 : 0
  name                                     = "eks-cluster-sg"
  description                              = "Allow TLS inbound traffic"
  vpc_id                                   = var.vpc_id

  ingress {
     description                           = "TLS from VPC"
    from_port                              = 443
    to_port                                = 443
    protocol                               = "tcp"
    cidr_blocks                            = ["10.0.0.0/16"]
  }
  ingress {
    description                            = "TCP 10250"
    from_port                              = 10250
    to_port                                = 10250
    protocol                               = "tcp"
    cidr_blocks                            = ["10.0.0.0/16"]
  }
  ingress {
    description                            = "TCP 53"
    from_port                              = 53
    to_port                                = 53
    protocol                               = "tcp"
    cidr_blocks                            = ["10.0.0.0/16"]
  }
  ingress {
    description                            = "UDP 53"
    from_port                              = 53
    to_port                                = 53
    protocol                               = "udp"
    cidr_blocks                            = ["10.0.0.0/16"]
  }
  
  egress {
    from_port                              = 0
    to_port                                = 0
    protocol                               = "-1"
    cidr_blocks                            = ["0.0.0.0/0"]
  }

 /*  tags = {
    "kubernetes.io/cluster/cluster-name" = "owned",
    "aws:eks:cluster-name"               = var.cluster_name
  } */
}

/* resource "aws_security_group_rule" "eks_allow_443" {
    type              = "ingress"
     description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  security_group_id = aws_security_group.eks_cluster_sg.id
}

resource "aws_security_group_rule" "eks_allow_10250" {
    type              = "ingress"
   description      = "TCP 10250"
    from_port        = 10250
    to_port          = 10250
    protocol         = "tcp"
    cidr_blocks      = ["10.0.0.0/16"]
  security_group_id = aws_security_group.eks_cluster_sg.id
} */

module "eks_addon" {
  depends_on                                  = [aws_eks_cluster.eks_cluster]
  source                                      = "./aws-eks-addons"
  eks_addons                                  = var.eks_addons
  cluster_name                                = aws_eks_cluster.eks_cluster[0].name    
}

module "eks_node_group"{
  depends_on                                  = [aws_eks_cluster.eks_cluster]
  source                                      = "./eks-node-group"
  node_role_arn                               = var.node_role_arn
  key_name                                    = var.key_name
  vpc_id                                      = var.vpc_id
  eks_node_group                              = var.eks_node_group
  ami_release_version                         = var.ami_release_version
  create_launch_template                      = var.create_launch_template
  launch_template_version                     = var.launch_template_version
  launch_template_name                        = var.launch_template_name
  launch_template_use_name_prefix             = var.launch_template_use_name_prefix
}

module "eks_oidc" {
  depends_on                                 = [aws_eks_cluster.eks_cluster]
  source                                     = "./eks_oidc"
  enable_oidc                                = var.enable_oidc
  cluster_name                               = aws_eks_cluster.eks_cluster[0].name 
  /*client_id                                = var.client_id
  identity_provider_config_name            = var.identity_provider_config_name
  issuer_url                               = var.issuer_url
  groups_claim                             = var.groups_claim
  groups_prefix                            = var.groups_prefix
  required_claims                          = var.required_claims
  username_claim                           = var.username_claim
  username_prefix                          = var.username_prefix */
}

module "eks_fargate" {
  depends_on                                  = [aws_eks_cluster.eks_cluster]
  source                                      = "./eks_fargate"
  enable_fargate                              = var.enable_fargate
  cluster_name                                = aws_eks_cluster.eks_cluster[0].name
  pod_execution_role_arn                      = var.pod_execution_role_arn
  subnet_ids                                  = var.eks_cluster_subnets
  fargate_profile                             = var.fargate_profile                        
}