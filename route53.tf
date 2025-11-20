resource "aws_route53domains_registered_domain" "domain_name" {
    domain_name = "multiplatform-project.com"

    # Contact information of regisstrant contact, admin contact and  tech contact

    registrant_contact {
    first_name =var.first_name
    last_name = var.last_name
    contact_type = "PERSON"
    organization_name = ""
    address_line_1 = var.address
    city = var.city
    state = var.state
    country_code = var.code
    zip_code = var.zip_code
    phone_number = var.number
    email = var.email
    }

    admin_contact {
    first_name =var.first_name
    last_name = var.last_name
    contact_type = "PERSON"
    organization_name = ""
    address_line_1 = var.address
    city = var.city
    state = var.state
    country_code = var.code
    zip_code = var.zip_code
    phone_number = var.number
    email = var.email

    }

    tech_contact {
    first_name =var.first_name
    last_name = var.last_name
    contact_type = "PERSON"
    organization_name = ""
    address_line_1 = var.address
    city = var.city
    state = var.state
    country_code = var.code
    zip_code = var.zip_code
    phone_number = var.number
    email = var.email
    }

    #Privacy Protection
    admin_privacy  = true
    registrant_privacy = true
    tech_privacy = true
    transfer_lock = true
}


resource "aws_route53_zone" "main_hosted_zone" {
    name = "multiplatform-project.com"

    tags = {
        Name = "main-hosted-zone"
    }

}

resource "aws_route53_record" "dns_records" {
    zone_id = aws_route53_zone.main_hosted_zone.id
    name = "multiplatform-project.com"
    type = "A"

    alias {
        name = aws_lb.alb.dns_name
        zone_id = aws_lb.alb.zone_id
        evaluate_target_health = true


    }


}


resource "aws_acm_certificate" "cert" {
    domain_name = "multiplatform-project.com"
    validation_method = "DNS"

    lifecycle {
    create_before_destroy = true

    }

    tags = {
      Name = "Multi-platform-cert"
    }


}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  zone_id = aws_route53_zone.main_hosted_zone.id
  ttl     = 60
}
