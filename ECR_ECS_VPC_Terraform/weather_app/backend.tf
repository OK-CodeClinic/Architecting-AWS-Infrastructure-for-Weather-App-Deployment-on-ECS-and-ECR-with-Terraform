## Storing Terraform state file in an s3 bucket

terraform {
  backend "s3" {
    bucket = "weather-app-ecs-state-file"
    key    = "weather-app.tfstate"
    region = "eu-west-1"
  }
}
