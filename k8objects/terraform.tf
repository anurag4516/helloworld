provider "aws" {
    region ="us-east-1"
}
resource "aws_security_group" "terraform_sg"{
name ="Security_Group_for_EC2_plus_Terraform"
ingress {

    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

}
resource "aws_instance" "terraform_demo_ec2"{
    ami ="ami-40d28157"
    instance_type="t2.micro"
    tags {
        name = "terraform_demo_example"
    }
}