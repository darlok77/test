terraform {
  backend "s3" {
    bucket  = "mdsdalleau"
    encrypt = true
    key     = "live/eu-west-2/bastion/terraform.state"
    region  = "eu-west-2"
  }
}
