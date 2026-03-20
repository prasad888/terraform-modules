resource "aws_s3_bucket" "s3-_bucket" {
  bucket = "${var.bucket_name}"
  tags = {
    Name = "${var.bucket_name}"
  }
  
}