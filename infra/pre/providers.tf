provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn = "arn:aws:iam::<PRE_ACCOUNT_ID>:role/tofu-pre"
  }
}