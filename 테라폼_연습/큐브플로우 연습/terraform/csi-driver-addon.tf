resource "aws_eks_addon" "csi_driver" {
  cluster_name             = aws_eks_cluster.test_eks.name
  addon_name               = "aws-ebs-csi-driver"
  service_account_role_arn = aws_iam_role.eks_ebs_csi_driver.arn
  depends_on = [
    aws_eks_node_group.admin_node_group
  ]
}