terraform {
  backend "s3" {
    bucket = "prasad-s3-demo-xyz"
    key    = "prasad/terraform.tfstate"
    region = var.region
    encrypt = true 
    dynamodb_table = "terraform-lock"   
    
  }
}