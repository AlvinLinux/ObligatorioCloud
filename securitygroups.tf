# Cramos un security group para permitir traffico http
resource "aws_security_group" "allow_http" {
    name = "Allow http traffic"
    vpc_id = aws_vpc.new_vpc.id

    ingress {
        description = "http from vpc"
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [aws_vpc.new_vpc.cidr_block]
    }
        ingress {
        description = "https from vpc"
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [aws_vpc.new_vpc.cidr_block]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web traffic"
    }
}

# Cramos un security group para permitir traffico entrante ssh
resource "aws_security_group" "allow_ssh" {
    name = "Allow ssh traffic"
    vpc_id = aws_vpc.new_vpc.id

    ingress {
        description = "ssh from vpc"
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "ssh traffic"
    }
}