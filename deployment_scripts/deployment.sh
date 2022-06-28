#!/bin/bash
# Descargamos las key configuradas en Github para poder descargar los archivos
cd ~/.ssh/
aws s3 cp s3://terraformab-bucket/id_rsa ./
aws s3 cp s3://terraformab-bucket/id_rsa.pub ./
chmod 600 id_rsa
chmod 600 id_rsa.pub
cd /home/ec2-user/

# Se hace un clone de la Online boutique a la maquina
GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" git clone git@github.com:AlvinLinux/online-boutique-Obligatorio.git

# Nos conectamos al cluster de EKS
aws eks --region us-east-1 update-kubeconfig --name bitbeat-eks-cluster

# Generamos la password para acceder al repositorio ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 300305432537.dkr.ecr.us-east-1.amazonaws.com


# Generan imagenes para cada uno de los Dockerfile y se carga en el reposiorio de ECR
path_to_file=($(find /home/ec2-user/online-boutique-Obligatorio/ -type f -name "Dockerfile"))

for i in ${path_to_file[@]};
do
        i=${i//Dockerfile/}
        cd $i
        tag=($(pwd | cut -d/ -f 6))
        docker build -t $tag:v1 .
        docker tag $tag:v1 300305432537.dkr.ecr.us-east-1.amazonaws.com/bitbeat-images:$tag"v1"
        docker push 300305432537.dkr.ecr.us-east-1.amazonaws.com/bitbeat-images:$tag"v1"
	sleep 15
done
