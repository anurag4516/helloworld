provider "aws" {
        region ="us-east-1"
}
variable "server_port" {
    description = "For specifying variable Port"
    default = 8080
}
resource "aws_security_group" "terraform_sg"{
name ="Security_Group_for_EC2_plus_Terraform_Latest"
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
    user_data = <<-EOF
    #!/bin/bash
    echo "Hello, World" > index.html
    nohup busybox httpd -f -p 8080 &
    EOF
    tags {
        name = "terraform_demo_example"
    }
}
resource "aws_launch_configuration" "autoscaling_lauch_config" {
    image_id = "ami-40d28157"
    instance_type = "t2.micro"
    security_groups = ["${aws_security_group.terraform_sg.id}"]
        user_data = <<-EOF
        #!/bin/bash
        echo "Hello, World" > index.html
        nohup busybox httpd -f -p "${var.server_port}" &
        EOF
        lifecycle {
        create_before_destroy = true
    }
}
resource "aws_autoscaling_group" "example" {
    launch_configuration = "${aws_launch_configuration.autoscaling_lauch_config.id}"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
    min_size = 2
    max_size = 10
    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}
resource "aws_elb" "example" {
    name = "terraform-asg-example"
    availability_zones = ["${data.aws_availability_zones.all.names}"]
}
output "public_ip" {
value = "${aws_instance.terraform_demo_ec2.public_ip}"
}