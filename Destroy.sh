#!/usr/bin/env bash

REPO_USER='angeloch1365'
AWS_REGION='us-east-1'
S3_BUCKET_NAME='node-app-tf-state-nm1ruznhbx2l'
LOCK_TABLE_NAME='tf-state-lock'
REPO_PASS='aeef361fb9172ea18b4aab21a9bba9f656f22cc3'
REPO_NAME='node-app'
REPO_EMAIL='angelo.hernandez@cloudhesive.com'

# Pull the repo
git clone https://github.com/${REPO_USER}/node-app.git

# Destroy the node-app deployment (from tfstate file in s3)
cd config/node-app
terraform init \
  -backend-config="region=${AWS_REGION}" \
  -backend-config="bucket=${S3_BUCKET_NAME}" \
  -backend-config="dynamodb_table=${LOCK_TABLE_NAME}"
terraform destroy \
  -auto-approve \
  -var "aws_region=${AWS_REGION}"

# Delete node-app deployment state from s3
aws s3 rm "s3://${S3_BUCKET_NAME}/terraform.tfstate"

# Destroy the s3 & dynamodb deployment
cd ../backend
terraform init
terraform destroy --auto-approve

# Commit the tfstate back (now containing nothing)
cd ../../  # get back to root
git add config/backend/terraform.tfstate
git \
  -c user.name="${REPO_NAME}" \
  -c user.email="${REPO_EMAIL}" \
  commit \
  -m "terraform backend destroyed in AWS"
git push "https://${REPO_USER}:${REPO_PASS}@github.com/${REPO_USER}/node-app.git master"