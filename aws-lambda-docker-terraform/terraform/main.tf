
resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-unique-s3-data-bucket"
 
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "14"
  instance_class       = "db.t3.micro"
  identifier           = "my-rds-instance"
  username             = "dbadmin"
  password             = "password123"
  skip_final_snapshot  = true
}

resource "aws_glue_catalog_database" "glue_db" {
  name = "my_glue_database"
}

resource "aws_ecr_repository" "data_processing_repo" {
  name = "data-processing"
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "lambda_basic_execution" {
  name       = "lambda_basic_execution"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
resource "aws_lambda_function" "data_processor" {
  function_name = "data_processor_lambda"
  role          = aws_iam_role.lambda_role.arn
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.data_processing_repo.repository_url}:latest"
  timeout       = 60
}