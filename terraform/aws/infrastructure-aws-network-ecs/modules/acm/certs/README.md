## About this Module
This terraform module create SSL certificates using AWS certificate manager service. Two validation methods are supported; Email and DNS. DNS is the preferred validation method since it guarantees automatic certificate renewal.

Variable required to run this module are:

* certificate_transparency_logging_preference (ENABLED/DISABLED): This is an optional parameter which determines whether certificate details should be added to a certificate transparency log or not. Default value is ENABLED.
* domain_name: The certificate domain name
* domain_validation_options (DNS/EMAIL): Use this variable to set the validation method for the certificate
* subject_alternative_names: A list variable of set of domains that should be subject alternative names in the issued certificate
* env: The environment the certificate belongs to, used only for tags.
* process_domain_validation_options and wait_for_certificate_issued (true/false): These to values must be "true" in order to validate the created certificate. Default values are "true"




------------------------------------------
This Terraform code defines four AWS resources:

* aws_acm_certificate: A resource to request a certificate from Amazon Certificate Manager (ACM) using either DNS or email validation.

* aws_route53_record: A resource to create DNS validation records in a specified Route 53 hosted zone, required to validate the domain ownership for the ACM certificate.
aws_acm_certificate_validation: A resource to validate the requested ACM certificate.

* data_aws_route53_zone: A data source to retrieve information about a specified Route 53 hosted zone.

* The AWS ACM certificate resource, "aws_acm_certificate", creates either a certificate with DNS validation (cert_dns) or email validation (cert_email), based on the value of the variable "domain_validation_options". The certificate properties, such as the domain name, subject alternative names, validation method, and certificate transparency logging preference, are defined as variables in this resource.

* The AWS Route 53 record resource, "aws_route53_record", creates DNS validation records for the ACM certificate using DNS validation. This resource references the AWS ACM certificate resource, "aws_acm_certificate.cert_dns", and retrieves the necessary information for creating the validation records.

* The AWS ACM certificate validation resource, "aws_acm_certificate_validation", validates the ACM certificate using the DNS validation records created by the AWS Route 53 record resource. This resource also references the AWS ACM certificate resource, "aws_acm_certificate.cert_dns".

* The data source, "data_aws_route53_zone", retrieves information about the specified Route 53 hosted zone. The hosted zone is determined by the value of the "dns_zone" variable.


The code also includes tags and depends_on relationships to manage the order in which resources are created and the dependencies between resources. The tags are used to identify the hosted zone and environment, while the depends_on relationships are used to manage the dependencies between resources, ensuring that resources are created in the correct order.