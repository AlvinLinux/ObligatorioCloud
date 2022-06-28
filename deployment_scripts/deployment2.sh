#!/bin/bash

aws eks --region us-east-1 update-kubeconfig --name bitbeat-eks-cluster --profile AlvaroB

path_to_file2=($(find /home/ec2-user/online-boutique-Obligatorio/ -type f -name "kubernetes-manifests2.yaml"))

for e in ${path_to_file2[@]};
do
       kubectl create -f $e
       sleep 4
done
