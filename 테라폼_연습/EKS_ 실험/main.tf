# module "public_eks_cluster" {
#   source         = "git::https://github.com/Noura98Houssien/simple-EKS-cluster.git?ref=v0.0.1"
#   vpc_name       = "my-VPC1"
#   cluster_name   = "my-EKS1"
#   desired_size   = 2
#   max_size       = 2
#   min_size       = 1
#   instance_types = ["t3.medium"]
# }

# resource "helm_release" "nginx-ingress-controller" {
#   name       = "nginx-ingress-controller"
#   repository = "https://charts.bitnami.com/bitnami"
#   chart      = "nginx-ingress-controller"


#   set {
#     name  = "service.type"
#     value = "LoadBalancer"
#   }

# }

# resource "kubernetes_pod_v1" "app1" {
#   metadata {
#     name = "my-app1"
#     labels = {
#       "app" = "app1"
#     }
#   }

#   spec {
#     container {
#       image = "hashicorp/http-echo"
#       name  = "my-app1"
#       args  = ["-text=Hello from my app 1"]
#     }
#   }
# }
# resource "kubernetes_service_v1" "app1_service" {
#   metadata {
#     name = "my-app1-service"
#   }
#   spec {
#     selector = {
#       app = kubernetes_pod_v1.app1.metadata.0.labels.app
#     }
#     port {
#       port = 5678
#     }
#   }
# }
# resource "kubernetes_ingress_v1" "ingress" {
#   wait_for_load_balancer = true
#   metadata {
#     name = "simple-fanout-ingress"
#   }

#   spec {
#     ingress_class_name = "nginx"

#     rule {
#       http {
#         path {
#           backend {
#             service {
#               name = "my-app1-service"
#               port {
#                 number = 5678
#               }
#             }
#           }

#           path = "/app1"
#         }

#         path {
#           backend {
#             service {
#               name = "my-app2-service"
#               port {
#                 number = 5678
#               }
#             }
#           }

#           path = "/app2"
#         }
#       }
#     }

#   }
# }