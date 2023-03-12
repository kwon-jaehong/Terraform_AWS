# resource "aws_efs_file_system" "eks" {
#   creation_token = "eks"

#   performance_mode = "generalPurpose"
#   throughput_mode  = "bursting"
#   encrypted        = true

#   tags = {
#     Name = "eks"
#   }
# }

# resource "aws_efs_mount_target" "zone-a" {
#   file_system_id  = aws_efs_file_system.eks.id
#   subnet_id       = aws_subnet.eks_public_1.id
#   security_groups = [aws_eks_cluster.chunjae_ocr.vpc_config[0].cluster_security_group_id]
#   depends_on = [
#     aws_eks_cluster.chunjae_ocr
#   ]
# }

# resource "aws_efs_mount_target" "zone-b" {
#   file_system_id  = aws_efs_file_system.eks.id
#   subnet_id       = aws_subnet.eks_public_2.id
#   security_groups = [aws_eks_cluster.chunjae_ocr.vpc_config[0].cluster_security_group_id]
#     depends_on = [
#     aws_eks_cluster.chunjae_ocr
#   ]
# }