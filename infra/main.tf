resource "aws_instance" "app_server" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  tags = {
    Name = "learn-terraform"
  }
}
