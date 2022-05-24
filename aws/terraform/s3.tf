//Create s3 bucket where the files will be uploaded
resource "aws_s3_bucket" "importBucket" {
  bucket = var.bucket_name

  tags = {
    Name = "import Bucket"
  }
}
