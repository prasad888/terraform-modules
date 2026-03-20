terraform {
  backend "s3" {
    bucket = "prasad-s3-demo-xyz"
    key    = "prasad/terraform.tfstate"
    region = ap-south-1
    encrypt = true 
    dynamodb_table = "terraform-lock"   
    
  }
}