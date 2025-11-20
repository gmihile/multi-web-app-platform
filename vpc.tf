resource "aws_vpc" "vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_support = true
    enable_dns_hostnames = true


    tags = {
        Name = "my-vpc"
    }

}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id

    tags = {
        Name = "my_aws_internet_gateway"
    }


}

resource "aws_nat_gateway" "aws_nat_gw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id =  aws_subnet.public_subnet_1.id
    tags = {
        Name = "aws-nat-gateway"
    }




}


resource "aws_eip" "nat_eip" {
    domain =  "vpc"
    tags = {
        Name = "nat-gw-elastic-ip"
    }


}




resource "aws_subnet" "public_subnet_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.first_public_subnet
    availability_zone = var.first_az
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet_1"
    }
}

resource  "aws_subnet"  "public_subnet_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.second_public_subnet
    availability_zone = var.second_az
    map_public_ip_on_launch = true

    tags = {
        Name = "public_subnet_2"
    }
}


resource "aws_subnet" "public_subnet_3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.third_public_subnet
    availability_zone = var.third_az
    map_public_ip_on_launch = true
    tags = {
        Name = "public_subnet_3"
    }
}

resource "aws_subnet" "private_subnet_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.first_private_subnet
    availability_zone = var.first_az

    tags = {
        Name = "private_subnet_1"
    }



}

resource "aws_subnet" "private_subnet_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.second_private_subnet
    availability_zone = var.second_az

    tags = {
        Name = "private_subnet_2"
    }
}

resource "aws_subnet" "private_subnet_3" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = var.third_private_subnet
    availability_zone = var.third_az

    tags = {
        Name = "private_subnet_3"
    }
}

resource "aws_subnet" "rds_private_subnet_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block =  var.first_rds_subnet
    availability_zone = var.first_az

    tags = {
        Name = "first_rds_subnet"
    }
}



resource "aws_subnet" "rds_private_subnet_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block =  var.second_rds_subnet
    availability_zone = var.second_az
    tags = {
        Name = "second_rds_subnet"
    }
}


resource "aws_route_table" "public_route_table" {
    vpc_id =  aws_vpc.vpc.id

    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "my_public_route_table"
    }


}

resource "aws_route_table" "private_route_table" {
     vpc_id = aws_vpc.vpc.id

    route   {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.aws_nat_gw.id
    }


    tags = {
        Name = "my_private_route_table"
    }
}


resource "aws_route_table_association" "aws_public_rt_associtation_1" {
    subnet_id = aws_subnet.public_subnet_1.id
    route_table_id = aws_route_table.public_route_table.id
}



resource "aws_route_table_association" "aws_public_rt_associtation_2" {
    subnet_id = aws_subnet.public_subnet_2.id
    route_table_id = aws_route_table.public_route_table.id
}


resource "aws_route_table_association" "aws_public_rt_associtation_3" {
    subnet_id = aws_subnet.public_subnet_3.id
    route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "aws_private_rt_associtation1" {
    subnet_id = aws_subnet.private_subnet_1.id
    route_table_id = aws_route_table.private_route_table.id
}


resource "aws_route_table_association" "aws_private_rt_associtation2" {
    subnet_id = aws_subnet.private_subnet_2.id
    route_table_id = aws_route_table.private_route_table.id
}


resource "aws_route_table_association" "aws_private_rt_associtation3" {
    subnet_id = aws_subnet.private_subnet_3.id
    route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "aws_rds_private_rt_association" {
    subnet_id = aws_subnet.rds_private_subnet_1.id
    route_table_id = aws_route_table.private_route_table.id

}

resource "aws_route_table_association" "aws_rds_private_rt_association2" {
    subnet_id = aws_subnet.rds_private_subnet_2.id
    route_table_id = aws_route_table.private_route_table.id

}
