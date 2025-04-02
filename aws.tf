
# Create an IAM role for Lambda function
resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "lambda-execution-role"
  }
}

# Create the Lambda function
resource "aws_lambda_function" "my_lambda" {
  function_name = "my_lambda_function"

  # Lambda function runtime (e.g., Python, Node.js)
  runtime = "python3.8"  # Change to your desired runtime, such as python3.8, nodejs14.x, etc.

  # Path to the Lambda function code
  filename         = "lambda_function_payload.zip"  # Path to your deployment package (ZIP file)
  source_code_hash = filebase64sha256("lambda_function_payload.zip")  # Base64 hash of the deployment package

  # IAM role that Lambda will assume
  role = aws_iam_role.lambda_execution_role.arn

  # Handler (the entry point of the Lambda function)
  handler = "lambda_function.lambda_handler"  # Change this to the appropriate handler for your runtime

  memory_size = 128  # Set memory size for your Lambda (in MB)
  timeout     = 10   # Timeout in seconds

  tags = {
    Name = "my-lambda"
  }
}

# Create a CloudWatch log group for Lambda (optional)
resource "aws_cloudwatch_log_group" "my_lambda_log_group" {
  name = "/aws/lambda/${aws_lambda_function.my_lambda.function_name}"
}

# Example output to show the Lambda function ARN
output "lambda_function_arn" {
  value = aws_lambda_function.my_lambda.arn
}
