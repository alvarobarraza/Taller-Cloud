terraform {
 required_providers {
   aws = {
     source = "hashicorp/aws"
   }
 }
}
    
provider "aws" {
  region = "us-east-1"
}

resource "aws_dynamodb_table" "tf_employees_table" {
 name = "tf_employees_table"
 billing_mode = "PROVISIONED"
 read_capacity= "30"
 write_capacity= "30"
 attribute {
  name = "employeesId"
  type = "S"
 }
 hash_key = "employeesId"

 ttl {
  enabled = true 
  attribute_name = "expiryPeriod" 
 }

 point_in_time_recovery {
   enabled = true
 }

 server_side_encryption {
   enabled = true 
   }
}
resource "aws_iam_role" "iam_for_lambda" {
 name = "iam_for_lambda"

 assume_role_policy = jsonencode({
   "Version" : "2012-10-17",
   "Statement" : [
     {
       "Effect" : "Allow",
       "Principal" : {
         "Service" : "lambda.amazonaws.com"
       },
       "Action" : "sts:AssumeRole"
     }
   ]
  })
}
          
resource "aws_iam_role_policy_attachment" "lambda_policy" {
   role = aws_iam_role.iam_for_lambda.name
   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
          
resource "aws_iam_role_policy" "dynamodb-lambda-policy" {
   name = "dynamodb_lambda_policy"
   role = aws_iam_role.iam_for_lambda.id
   policy = jsonencode({
      "Version" : "2012-10-17",
      "Statement" : [
        {
           "Effect" : "Allow",
           "Action" : ["dynamodb:*"],
           "Resource" : "${aws_dynamodb_table.tf_employees_table.arn}"
        }
      ]
   })
}

data "archive_file" "create-employees-archive" {
 source_file = "lambdas/create-employees.js"
 output_path = "lambdas/create-employees.zip"
 type = "zip"
}

resource "aws_lambda_function" "create-employees" {
 environment {
   variables = {
     EMPLOYEES_TABLE = aws_dynamodb_table.tf_employees_table.name
   }
 }
 memory_size = "128"
 timeout = 10
 runtime = "nodejs14.x"
 architectures = ["arm64"]
 handler = "lambdas/create-employees.handler"
 function_name = "create-employees"
 role = aws_iam_role.iam_for_lambda.arn
 filename = "lambdas/create-employees.zip"
}

data "archive_file" "delete-employees-archive" {
 source_file = "lambdas/delete-employees.js"
 output_path = "lambdas/delete-employees.zip"
 type = "zip"
}

resource "aws_lambda_function" "delete-employees" {
 environment {
   variables = {
    EMPLOYEES_TABLE = aws_dynamodb_table.tf_employees_table.name
   }
 }
 memory_size = "128"
 timeout = 10
 runtime = "nodejs14.x"
 architectures = ["arm64"]
 handler = "lambdas/delete-employees.handler"
 function_name = "delete-employees"
 role = aws_iam_role.iam_for_lambda.arn
 filename = "lambdas/delete-employees.zip"
}

data "archive_file" "get-all-employees-archive" {
 source_file = "lambdas/get-all-employees.js"
 output_path = "lambdas/get-all-employees.zip"
 type = "zip"
}

resource "aws_lambda_function" "get-all-employees" {
 environment {
   variables = {
     EMPLOYEES_TABLE = aws_dynamodb_table.tf_employees_table.name
   }
 }
 memory_size = "128"
 timeout = 10
 runtime = "nodejs14.x"
 architectures = ["arm64"]
 handler = "lambdas/get-all-employees.handler"
 function_name = "get-all-employees"
 role = aws_iam_role.iam_for_lambda.arn
 filename = "lambdas/get-all-employees.zip"
}


resource "aws_apigatewayv2_api" "employees_api" {
  name          = "employees-api"
  protocol_type = "HTTP"
}

resource "aws_apigatewayv2_stage" "employees_api" {
  api_id = aws_apigatewayv2_api.employees_api.id

  name        = "employees-api"
  auto_deploy = true

}

resource "aws_apigatewayv2_integration" "create-employees" {
  api_id = aws_apigatewayv2_api.employees_api.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.create-employees.invoke_arn
}

resource "aws_lambda_permission" "create-employees" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create-employees.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.employees_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "create-employees" {
  api_id    = aws_apigatewayv2_api.employees_api.id
  route_key = "POST /employees"

  target = "integrations/${aws_apigatewayv2_integration.create-employees.id}"
}


resource "aws_apigatewayv2_integration" "delete-employees" {
  api_id = aws_apigatewayv2_api.employees_api.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.delete-employees.invoke_arn
}

resource "aws_lambda_permission" "delete-employees" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.delete-employees.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.employees_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "delete-employees" {
  api_id    = aws_apigatewayv2_api.employees_api.id
  route_key = "DELETE /employees"

  target = "integrations/${aws_apigatewayv2_integration.delete-employees.id}"
}


resource "aws_apigatewayv2_integration" "get-all-employees" {
  api_id = aws_apigatewayv2_api.employees_api.id

  integration_type   = "AWS_PROXY"
  integration_method = "POST"
  integration_uri    = aws_lambda_function.get-all-employees.invoke_arn
}

resource "aws_lambda_permission" "get-all-employees" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.get-all-employees.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_apigatewayv2_api.employees_api.execution_arn}/*/*"
}

resource "aws_apigatewayv2_route" "get-all-employees" {
  api_id    = aws_apigatewayv2_api.employees_api.id
  route_key = "GET /employees"

  target = "integrations/${aws_apigatewayv2_integration.get-all-employees.id}"
}



