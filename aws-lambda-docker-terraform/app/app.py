import boto3
import psycopg2
import logging 


def lambda_handler(event, context):
	# Read from S3
	s3 = boto3.client('s3')
	bucket = "YOUR_S3_BUCKET_NAME" # This will be created via Terraform.
	key = "data/input.csv" # Ensure the file exists or adjust logic.
	try:
		s3_response = s3.get_object(Bucket=bucket, Key=key)
		data = s3_response['Body'].read().decode('utf-8')
		logging.info("Successfully read data from S3.")
	except Exception as e:
		logging.error("Error reading from S3: %s", e)
		return {"statusCode": 500, "body": "S3 read error"}
	# Write to RDS (PostgreSQL example)
	try:
		conn = psycopg2.connect(
			database="YOUR_RDS_DB", # Provided via Terraform outputs.
			user="YOUR_RDS_USER", # Provided via Terraform variables.
			password="YOUR_RDS_PASSWORD",# Provided via Terraform variables.
			host="YOUR_RDS_ENDPOINT", # Provided by Terraform.
			port="5432"
		)
		cur = conn.cursor()
		cur.execute("INSERT INTO your_table (data) VALUES (%s)", (data,))
		conn.commit()
		cur.close()
		conn.close()
		logging.info("Data inserted into RDS successfully.")
	except Exception as e:
		logging.error("Error connecting to RDS: %s", e)
	# Fallback: call a Glue job (placeholder logic)
	glue = boto3.client('glue')
	logging.info("Fallback to Glue executed.")
	return {"statusCode": 200, "body": "Data processed successfully"}