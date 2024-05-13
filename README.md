
# Terraform Deployment for Dockerized Weather-Application on AWS Fargate

## Description
This project aims to deploy a Dockerized application on AWS Fargate using Terraform. It covers the provisioning of necessary AWS resources such as VPC, subnets, NAT Gateway, Internet Gateway, route tables, security groups, ACM certificate, load balancer, and target groups.
![new_fargate](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/assets/100064229/3c991e1d-9e0a-41ff-989d-4e7c42e1e155)


## Prerequisites

- Install [Terraform](https://www.terraform.io/downloads.html) .
- AWS credentials configured with appropriate permissions.
- Docker installed locally.
- An existing Route 53 hosted zone for your domain.


## Usage
- Set up docker engine
  Download docker engine using the script here:![docker](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/blob/main/docker.sh) 
- Build the docker image
![Screenshot (345)](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/assets/100064229/6cbdd034-a5f9-49e6-81d6-98ba469babba)


- Push it to ECR using ECR push commands.
  ![Screenshot (353)](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/assets/100064229/b7f235b4-2d58-499b-9e3d-a904003e8562)

  - image

  ![Screenshot (354)](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/assets/100064229/15d0dae1-9d80-4d5e-b0d6-44be59fbd956)


  
- Clone the repo.
```
git clone https://github.com/OK-CodeClinic/Architecting-AWS-Infrastructure-for-Weather-App-Deployment-on-ECS-and-ECR-with-Terraform


```

- Initilize terraform
```
terraform init
```

- Configure your AWS credentials: Ensure your AWS credentials are properly configured either through environment variables, AWS CLI configuration, or using a shared credentials file.

- Update Terraform variables: Modify the terraform.tfvars file to set appropriate values for your deployment, such as AWS region, VPC CIDR, subnets, domain name, etc.

- Review and customize Terraform code:

- Review the Terraform modules and code in the main.tf file to ensure it aligns with your deployment requirements. Make any necessary modifications.

- Apply terraform configuration and changes
```
terraform Apply
```



### What happens when terraform is applied in this scenario?
- Resource Creation:  it creates Elastic IP addresses (module.nat_gateway.aws_eip), VPC (module.vpc.aws_vpc), CloudWatch log groups (module.ecs.aws_cloudwatch_log_group), ACM certificate (module.acm.aws_acm_certificate), ECS cluster (module.ecs.aws_ecs_cluster), security groups (module.security_group.aws_security_group), load balancer (module.alb.aws_lb), etc.


- Terraform continues to provision resources such as subnets, route tables, NAT gateways, etc., required for networking and infrastructure setup.

- Route53 Record Creation: Terraform creates Route53 records (module.acm.aws_route53_record) to associate with the ACM certificate for domain validation.  The Route53 records are created for both the root domain (okproject.site) and subdomain (weather-app.okproject.site) in my case.

- Load Balancer Configuration: Terraform sets up the Application Load Balancer (ALB) and associated target groups (module.alb.aws_lb_target_group).
It configures listeners for HTTP and HTTPS traffic (module.alb.aws_lb_listener).


- Certificate Validation: Terraform begins the validation process for the ACM certificate (module.acm.aws_acm_certificate_validation) by creating Route53 records to prove domain ownership.

- As soon as all resource complete. The docker image will be running in the dns mapped to the hosted zone

![Screenshot (349)](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/assets/100064229/53e18383-ff86-4205-808b-a409756fcaad)


- Then check the domain or the sub domain provided in the tfvars file in the web brower. And Boom! app is working
  ![Screenshot (348)](https://github.com/OK-CodeClinic/Terraform-Deployment-for-Dockerized-Weather-Application-on-AWS-ECR-and-ECS-Fargate/assets/100064229/359c436f-ada9-455a-b7f8-675e016a4908)



### Cleanup
To destroy the created resources after testing.
``` terraform destroy ```.

#### Author
Kehinde Omokungbe

####  Acknowlegment
- docker/riverthead42
- Developer of the App : Hamza KOC











