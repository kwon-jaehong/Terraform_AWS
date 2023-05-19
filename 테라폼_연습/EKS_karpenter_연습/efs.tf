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
#   subnet_id       = aws_subnet.public-1a.id
#   security_groups = [aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]

# }

# resource "aws_efs_mount_target" "zone-b" {
#   file_system_id  = aws_efs_file_system.eks.id
#   subnet_id       = aws_subnet.public-1b.id
#   security_groups = [aws_eks_cluster.cluster.vpc_config[0].cluster_security_group_id]

# }



# resource "aws_efs_access_point" "test" {
#   file_system_id = aws_efs_file_system.eks.id
# }


# # Creating the AWS EFS System policy to transition files into and out of the file system.
# resource "aws_efs_file_system_policy" "policy" {
#   file_system_id = aws_efs_file_system.eks.id
# # The EFS System Policy allows clients to mount, read and perform 
# # write operations on File system 
# # The communication of client and EFS is set using aws:secureTransport Option
#   policy = <<POLICY
# {
#     "Version": "2012-10-17",
#     "Id": "Policy01",
#     "Statement": [
#         {
#             "Sid": "Statement",
#             "Effect": "Allow",
#             "Principal": {
#                 "AWS": "*"
#             },
#             "Resource": "${aws_efs_file_system.eks.arn}",
#             "Action": [
#                 "elasticfilesystem:ClientMount",
#                 "elasticfilesystem:ClientRootAccess",
#                 "elasticfilesystem:ClientWrite"
#             ],
#             "Condition": {
#                 "Bool": {
#                     "aws:SecureTransport": "false"
#                 }
#             }
#         }
#     ]
# }
# POLICY
# }