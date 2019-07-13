provider "aws" {
        region ="us-east-1"
}
variable "server_port" {
    description = "For specifying variable Port"
    default = 8080
}
resource "aws_security_group" "terraform_sg"{
name ="Security_Group_for_EC2_plus_Terraform"
ingress {

    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}
egress {

    from_port = "${var.server_port}"
    to_port = "${var.server_port}"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

}
resource "aws_instance" "terraform_demo_ec2"{
    ami ="ami-40d28157"
    instance_type="t2.micro"
    vpc_security_group_ids = ["${aws_security_group.terraform_sg.id}"]
    tags {
        name = "terraform_demo_example"
    }
}