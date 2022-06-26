# Indicamos el provider, region y perfil a utilizar
provider "aws" {
  region  = var.region
  profile = var.perfil
}

# Creamos la instancia que sera utilizada para hacer los deployments
resource "aws_instance" "TheDeploymentMachine" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  subnet_id              = aws_subnet.public_subnetA.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  root_block_device {
    tags        = {}
    volume_size = 20
  }
  key_name = "practico-networking"
  tags = {
    Name = "TheDeploymentMachine"

  }

  # Ejecutan comandos de forma local, para adjuntar LabRole a la instancia
  provisioner "local-exec" {

    command = <<-EOT

        instanceid=$(aws ec2 describe-instances --filters "Name=tag:Name,Values=TheDeploymentMachine" "Name=instance-state-name,Values=running" --profile AlvaroA | grep InstanceId | cut -d: -f 2)

        aws ec2 associate-iam-instance-profile --instance-id $instanceid --iam-instance-profile Name=LabInstanceProfile --profile AlvaroA

        EOT
  }
  # Copiamos el perfil de AWS a la instancia
  provisioner "file" {
    source      = "/home/alvin/.aws"
    destination = "/home/ec2-user/.aws"

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("/home/alvin/Obligatorio/practico-networking.pem")
      host        = self.public_ip
    }
  }


  #Datos de conexion con la instancia 
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/alvin/Obligatorio/practico-networking.pem")
    host        = self.public_ip
  }

  #Ejecutamos Comandos de forma remota sobre la instancia 
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/sbin/docker-compose",
      "sudo chmod +x /usr/local/sbin/docker-compose",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "sudo curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      "sudo yum install git -y",
      "aws s3 cp s3://terraformaa-bucket/deployment.sh ./ --profile AlvaroA",
      "sudo bash deployment.sh",
      "aws s3 cp s3://terraformaa-bucket/deployment-kubernetes.sh ./ --profile AlvaroA",
      "chmod 777 deployment-kubernetes.sh",
      "./deployment-kubernetes.sh",
    ]
  }
  depends_on = [aws_eks_node_group.worker-node-group]
}


