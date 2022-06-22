provider "aws" {
    region = var.region
    profile = var.perfil
}



/*# Creamos un load balncer para la aplicacion web

resource "aws_lb" "lb_webserver" {
    name    = "lb11"
    internal    =   false
    load_balancer_type  =   "application"
    security_groups = [aws_security_group.allow_http.id]
    subnets = [aws_subnet.public_subnet.id]
    enable_deletion_protection  =   false

}

module "nginx" {
    source  = "./Modules"
}

resource "aws_instance" "nginx" {
    count = var.instance_count
    ami = var.ami
    instance_type = "t2.micro"
    subnet_id = var.subnets
    vpc_security_group_ids = [aws_security_group.allow_http.id]
 #   vpc_security_group_ids = [aws_security_group.allow_ssh.id]
    key_name = "practico-networking"
    tags = {
        Name  = "nginx-${count.index + 1}"
        #Name  = "test"
  }
}
*/

resource "aws_instance" "TheDeploymentMachine" {
    ami = var.ami
    instance_type = "t2.micro"
    subnet_id = aws_subnet.public_subnetA.id
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
   # iam_instance_profile = aws_iam_role.LabRole.name
    key_name = "practico-networking"
    tags = {
        Name  = "TheDeploymentMachine"
 
    }
    
    connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file("/home/alvin/Practico2/practico-networking.pem")
    host        = self.public_ip
    }

   provisioner "local-exec" {
     command = "aws iam add-role-to-instance-profile --role-name LabRole --instance-profile-name TheDeploymentMachine"
   }



  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y docker",
      "sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/sbin/docker-compose",
      "sudo chmod +x /usr/local/sbin/docker-compose",
      "sudo systemctl enable docker",
      "sudo systemctl start docker",
      "curl -LO https://dl.k8s.io/release/v1.21.0/bin/linux/amd64/kubectl",
      "sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl",
      
      #"aws eks --region us-east-1 update-kubeconfig --name bitbeat-eks-cluster"
    ]
  }
  
  depends_on = [
      aws_eks_node_group.worker-node-group,
      aws_ecr_repository.bitbeat-images,
  ]
}

