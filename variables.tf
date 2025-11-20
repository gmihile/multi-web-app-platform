variable "region" {
    description = "Region this project will be deployed in"
    type = string
    default = "us-west-2"
}



variable "vpc_cidr" {
    description = "The vpc i'll be working in only"
    type = string
    default = "10.0.0.0/16"
}


variable "first_public_subnet" {
    description = "First public subnet that my ALB will live in"
    type = string
    default = "10.0.1.0/24"
}

variable  "second_public_subnet" {
    description = "Second public subnet that my ALB will live in"
    type = string
    default = "10.0.2.0/24"
}

variable "third_public_subnet" {
    description = "Third public subnet that my ALB will live in"
    type = string
    default = "10.0.3.0/24"
}


variable  "first_private_subnet" {
    description = "First private subnet that my ec2 instances will live in"
    type = string
    default = "10.0.4.0/24"

}

variable  "second_private_subnet" {
    description = "Second private subnet that my ec2 instances will live in"
    type = string
    default = "10.0.5.0/24"
}

variable  "third_private_subnet" {
    description = "Third private subnet that my ec2 instance will live in"
    type = string
    default = "10.0.6.0/24"
}

variable "first_rds_subnet" {
    description = "First private RDS Subnet"
    type = string
    default = "10.0.7.0/24"


}

variable "second_rds_subnet" {
    description = "Second private RDS Subnet"
    type = string
    default = "10.0.8.0/24"
}

variable "first_az" {
    description = "First availability zone"
    type = string
    default = "us-west-2a"

    }


variable "second_az" {
    description = "Second availability zone"
    type = string
    default = "us-west-2b"

    }


variable "third_az" {
    description = "Third availability zone"
    type = string
    default = "us-west-2c"

    }


variable "ami_value_pattern" {
    description = "ami pattern value for ami read"
    type = string
    default = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "user_data_script" {
    description = "User data script for my EC2 instances."
    type = string
    default = <<-EOF
    #!/bin/bash
    set -e
    yum update -y
    yum install -y httpd

    INSTANCE_ID=$(ec2-metadata --instance-id | cut -d " " -f 2)
    AZ=$(ec2-metadata --availability-zone | cut -d " " -f 2)

    # Create HTML page
    cat > /var/www/html/index.html <<HTML
    <h1>Instance ID: $INSTANCE_ID</h1>
    <p>AZ: $AZ</p>
    HTML

    systemctl start httpd
    systemctl enable httpd
    EOF


}

variable "minimum_instance_amount" {
    description = "minimum instance amount for ASG"
    type = number
    default = 1

}

variable "desired_instance_amount" {
    description = "desired instance amount for ASG"
    type = number
    default = 1

}

variable "maximum_instance_amount" {
    description = "maximuminstance amount for ASG"
    type = number
    default = 3

}

variable "instance_type" {
    description = "Type of instance that will be deployed in the ASG"
    type = string
    default = "t2.micro"
}

variable "health_check_grace_period" {
    description = "Amount of seconds for health check grace period"
    type = number
    default = 300

}


variable "db_instance_type" {
    description = "RDS instance type"
    type = string
    default = "t3.micro"

}

variable "first_name" {
    description = "First name"
    type = string
    default = "Gouled"

}

variable "last_name" {
    description = "Last name"
    type = string
    default = "Mihile"

}

variable "address" {
    description = "Address"
    type = string
    default = "3926 s 198th street"

}

variable "city" {
    description = "city"
    type = string
    default = "Seatac"

}

variable "state" {
    description = "state"
    type = string
    default = "Washington"

}

variable "code" {
    description = "Country Code"
    type = string
    default= "US"

}

variable "zip_code" {
    description = "zip code"
    type = string
    default = "98188"

}

variable "number" {
    description = "Phone number"
    type = string
    default = "2066653307"
}

variable "email" {
    description = "email"
    type = string
    default = "gmihile2@gmail.com"

}
