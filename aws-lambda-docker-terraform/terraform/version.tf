terraform {
required_version = ">= 0.14"
required_providers {
aws = {
source = "hashicorp/aws"
}
}
}
provider "aws" {
region = "us-east-1"


}
# add access key and secret key