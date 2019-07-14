provider "aws" {
        region ="us-east-1"
}
variable "server_port" {
    description = "For specifying variable Port"
    default = 8080
}
data "aws_availability_zones" "available" {
  state = "available"
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
    protocol = "-1"
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
    availability_zones = ["${data.aws_availability_zones.available.names[0]}" ,"${data.aws_availability_zones.available.names[1]}"]
    min_size = 2
    max_size = 10
    load_balancers = ["${aws_elb.terraformelb.name}"]
    health_check_type = "ELB"
    tag {
        key = "Name"
        value = "terraform-asg-example"
        propagate_at_launch = true
    }
}
resource "aws_elb" "terraformelb" {
    name = "terraform-asg-example"
    availability_zones = ["${data.aws_availability_zones.available.names[0]}" ,"${data.aws_availability_zones.available.names[1]}"]
   security_groups = ["${aws_security_group.terraform_sg.id}"]
    listener {
            lb_port = 80
            lb_protocol = "http"
            instance_port = "${var.server_port}"
            instance_protocol = "http"
    }
    health_check {
        healthy_threshold = 1
        unhealthy_threshold = 1
        timeout = 3
        interval = 30
        target = "HTTP:${var.server_port}/"
    }
}
output "public_ip" {
value = "${aws_instance.terraform_demo_ec2.public_ip}"
}
output "elb_dns_name" {
value = "${aws_elb.terraformelb.dns_name}"
}