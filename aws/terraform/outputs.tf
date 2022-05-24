output "outputhomeworkS3" {
  description = "s3 bucket id"
  value       = aws_s3_bucket.importBucket.id
}

output "outputhomeworkS3arn" {
  description = "s3 bucket arn"
  value       = aws_s3_bucket.importBucket.arn
}

output "homeworkimporterLambdaArn" {
  description = "lambda importer arn"
  value       = aws_lambda_function.lambda_importer.arn
}


