variable "domain"         { }
variable "vpc_id"         { }
variable "sub_domains"    { }
variable "web_private_ip" { }
variable "db_private_ip"  { }

resource "aws_route53_zone" "dns" {
  name   = "${var.domain}"
  vpc_id = "${var.vpc_id}"
}

resource "aws_route53_record" "dns" {
  count   = "${length(split(",", var.sub_domains))}"
  zone_id = "${aws_route53_zone.dns.zone_id}"
  name    = "${element(split(",", var.sub_domains), count.index)}.${var.domain}"
  type    = "A"
  ttl     = 60
  records = ["${var.web_private_ip}","${var.db_private_ip}"]
}

output "route53_record_fqdns" { value = "${join(",", aws_route53_record.dns.*.fqdn)}" }
