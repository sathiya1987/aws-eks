
cluster_name                       = "eks-terraform"
eks_cluster_role_arn               = "arn:aws:iam::297823336606:role/AWSRoleAmazonEKS"
eks_cluster_subnets                = ["subnet-0e22496b4e61f0414","subnet-02863ded1fb7e966a"]
kms_key_arn                        = "arn:aws:kms:us-west-1:297823336606:key/bc2399e0-73d6-4b66-8cda-fadb41d486b9"
vpc_id                             = "vpc-03d5a2d034f7e07b8"
node_role_arn                      = "arn:aws:iam::297823336606:role/AWS_EKS_NodeGroup_Role"
eks_addons = [
    {
      addon_name    = "kube-proxy"
      addon_version = "v1.21.2-eksbuild.2"
    },
    {
      addon_name    = "vpc-cni"
      addon_version = "v1.11.2-eksbuild.1"
    },
    {
      addon_name    = "aws-ebs-csi-driver"
      addon_version = "v1.8.0-eksbuild.0"
    },
    {
      addon_name    = "coredns"
      addon_version = "v1.8.7-eksbuild.1"
    }
  ]
#addon_version                  = "v1.22.6-eksbuild.1"
#ec2_ssh_key                    ="sathiya"
#ami_id                         ="ami-0d9858aa3c6322f73"
eks_node_group =[
{
    subnet_ids                 = ["subnet-0e22496b4e61f0414","subnet-02863ded1fb7e966a"]
    ami_type                   = "AL2_x86_64"
    capacity_type              = "SPOT"
    disk_size                  = 20
    instance_types             = ["t3.medium"]
    k8_version                 = "1.22"
    cluster_name               = "eks-terraform"
    force_update_version       = false
    labels = {
      platform = "apps"
      env      = "dev"
    }
    node_group_name            = "eks-terraform-node-group2"
    taints=[
      {
        key    ="platform"
        value  = "apps"
        effect = "NO_SCHEDULE"}
        ]

   ec2_ssh_key                = "sathiya"
    source_security_group_ids  = ["sg-06639def31e09c198"]
    desired_size               = 1
    max_size                   = 1
    min_size                   = 1
    max_unavailable            = 1
  #  max_unavailable_percentage = 0
    }
]
create_launch_template = true
#arn:aws:iam::297823336606:role/aws-service-role/eks-fargate.amazonaws.com/AWSServiceRoleForAmazonEKSForFargate