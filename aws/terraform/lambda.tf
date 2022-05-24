//Role for lambda importer
resource "aws_iam_role" "iam_for_lambda_importer" {
  name = "iam_for_lambda_importer"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

//Policy for lambda importer
resource "aws_iam_policy" "lambda_importer_policy" {
  name        = "lambda_importer_policy"
  path        = "/"
  description = "lambda importer policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances",
          "ec2:CreateNetworkInterface",
          "ec2:AttachNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_importer" {
  role       = aws_iam_role.iam_for_lambda_importer.name
  policy_arn = aws_iam_policy.lambda_importer_policy.arn
}


//Create Lambda importer
resource "aws_lambda_function" "lambda_importer" {

  filename      = "${path.module}./lambda/main.zip"
  function_name = "lambda_importer"
  role          = aws_iam_role.iam_for_lambda_importer.arn
  handler       = "main"
  runtime       = "go1.x"
  vpc_config {
    subnet_ids         = [aws_subnet.redis_subnet.id]
    security_group_ids = [aws_security_group.allow_redis_connection.id]
  }
  environment {
    variables = {
      redisHost = aws_elasticache_cluster.file_storage_node.cluster_address
      username  = var.redis_username
      password  = var.redis_password
      redisDB   = var.redis_DB
    }
  }
}

//Create permission for s3 execution
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_importer.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.importBucket.arn
}

//Create bucket notification
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.importBucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_importer.arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
