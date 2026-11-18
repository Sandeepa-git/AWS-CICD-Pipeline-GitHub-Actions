#!/usr/bin/env bash
# configure-aws.sh
# Provisions and configures AWS resources for the GitHub Actions CI/CD Pipeline.

set -euo pipefail

AWS_REGION="${AWS_REGION:-us-east-1}"
APP_NAME="aws-cicd-pipeline-app"
RANDOM_SUFFIX=$(date +%s)
BUCKET_NAME="${S3_BUCKET_NAME:-${APP_NAME}-${RANDOM_SUFFIX}}"

echo "=========================================="
echo " Setting up AWS Resources for CI/CD"
echo "=========================================="
echo "Region: ${AWS_REGION}"
echo "Bucket Name: ${BUCKET_NAME}"

# Verify AWS CLI installation
if ! command -v aws &> /dev/null; then
  echo "Error: AWS CLI is not installed or not in PATH."
  exit 1
fi

echo "Verifying AWS credentials..."
aws sts get-caller-identity > /dev/null
echo "AWS credentials verified successfully."

# 1. Create S3 Bucket
echo "Creating S3 bucket: ${BUCKET_NAME}..."
if [ "${AWS_REGION}" = "us-east-1" ]; then
  aws s3api create-bucket \
    --bucket "${BUCKET_NAME}" \
    --region "${AWS_REGION}"
else
  aws s3api create-bucket \
    --bucket "${BUCKET_NAME}" \
    --region "${AWS_REGION}" \
    --create-bucket-configuration LocationConstraint="${AWS_REGION}"
fi

# 2. Configure S3 Static Website Hosting
echo "Configuring static website hosting on bucket..."
aws s3 website "s3://${BUCKET_NAME}/" \
  --index-document index.html \
  --error-document index.html

echo "=========================================="
echo " Setup Finished Successfully!"
echo "=========================================="
echo "Add the following secrets in GitHub Repository Settings -> Secrets and variables -> Actions:"
echo "  AWS_ACCESS_KEY_ID:     <your-access-key-id>"
echo "  AWS_SECRET_ACCESS_KEY: <your-secret-access-key>"
echo "  AWS_REGION:            ${AWS_REGION}"
echo "  AWS_S3_BUCKET:         ${BUCKET_NAME}"
