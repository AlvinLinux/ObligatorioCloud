# Configuramos el terraform state para que se guarde en una bucket de s3
terraform {
  backend "s3" {
    bucket = "tfstate-obligatorio-cloud-ort"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "tfstate-obligatorio-cloud-ort"
    profile = "AlvaroA"
  }
}