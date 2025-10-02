resource "aws_lb" "nlb" {
name = "todoapp-nlb"
internal = false
load_balancer_type = "network"
subnets = [for s in aws_subnet.public : s.id]
tags = { Name = "todoapp-nlb" }
}


resource "aws_lb_target_group" "tg_3000" {
name = "todoapp-tg-3000"
port = 3000
protocol = "TCP"
vpc_id = aws_vpc.main.id


health_check {
protocol = "TCP"
port = "3000"
}
}


resource "aws_lb_listener" "listener_3000" {
load_balancer_arn = aws_lb.nlb.arn
port = 3000
protocol = "TCP"


default_action {
type = "forward"
target_group_arn = aws_lb_target_group.tg_3000.arn
}
}


# Also create listeners for 80 and 443 pointing to port 80 and 443 target groups
resource "aws_lb_target_group" "tg_80" {
name = "todoapp-tg-80"
port = 80
protocol = "TCP"
vpc_id = aws_vpc.main.id
health_check { protocol = "TCP" }
}


resource "aws_lb_listener" "listener_80" {
load_balancer_arn = aws_lb.nlb.arn
port = 80
protocol = "TCP"
default_action {
type = "forward"
target_group_arn = aws_lb_target_group.tg_80.arn
}
}


resource "aws_lb_target_group_attachment" "attach_3000" {
target_group_arn = aws_lb_target_group.tg_3000.arn
target_id = aws_instance.app.id
port = 3000
}


resource "aws_lb_target_group_attachment" "attach_80" {
target_group_arn = aws_lb_target_group.tg_80.arn
target_id = aws_instance.app.id
port = 80
}