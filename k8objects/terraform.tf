provider "aws" {
    region ="us-east-1"
}
resource "aws_instance" "terraform_demo_ec2"{
    ami ="ami-40d28157"
    instance_type="t2.micro"
    tags {
        name = "terraform_demo_example"
    }
}