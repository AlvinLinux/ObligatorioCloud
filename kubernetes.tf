# Creamos un cluster de elastic kubernetes service
resource "aws_eks_cluster" "cluster-eks" {
  name     = var.EKSClusterName
  role_arn = "arn:aws:iam::128364418855:role/LabRole"
  version  = "1.21"

  vpc_config {
    subnet_ids             = [aws_subnet.public_subnetA.id, aws_subnet.public_subnetB.id]
    endpoint_public_access = true
  }
}
resource "time_sleep" "wait_30_seconds" {
  depends_on = [aws_eks_cluster.cluster-eks]

  create_duration = "30s"
}

# Asignamos los worker goroups con la cantidad de instancias maximas y minimas requeridas
resource "aws_eks_node_group" "worker-node-group" {
  depends_on      = [time_sleep.wait_30_seconds]
  cluster_name    = "bitbeat-eks-cluster"
  node_group_name = var.WNName
  node_role_arn   = "arn:aws:iam::128364418855:role/LabRole"
  subnet_ids      = [aws_subnet.public_subnetA.id, aws_subnet.public_subnetB.id]
  instance_types  = ["t3.xlarge"]

  scaling_config {
    desired_size = 2
    max_size     = 2
    min_size     = 2
  }
}

# Se crea un repositorio para alojar las imagenes de Docker
resource "aws_ecr_repository" "bitbeat-images" {
  name                 = "bitbeat-images"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}