resource "aws_instance" "main_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.jenkins_sg_id]
  iam_instance_profile   = var.jenkins_instance_profile_name

  user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install openjdk-17-jdk -y
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
    sudo apt update
    sudo apt install jenkins -y
    sudo systemctl start jenkins
    sudo systemctl enable jenkins
    # Install ssh-agent
    sudo apt install openssh-client -y
    eval $(ssh-agent -s)

  EOF

  tags = {
    Name = "${var.name_prefix}-jenkins-server"
  }
}

resource "aws_instance" "app" {
  ami             = var.ami_id
  instance_type   = var.instance_type
  key_name        = var.key_name
  vpc_security_group_ids = [var.app_sg_id]

  tags = {
    Name = "${var.name_prefix}-app-server"
  }

  user_data = <<-EOF
    #!/bin/bash
    # Update the package list
    sudo apt update -y
    
    # Install Apache (httpd is referred to as apache2 in Ubuntu)
    sudo apt install -y apache2
    
    # Start and enable Apache on boot
    sudo systemctl start apache2
    sudo systemctl enable apache2
    sudo apt update
    sudo apt install -y nodejs npm
    mkdir -p /home/ubuntu
  EOF
}

