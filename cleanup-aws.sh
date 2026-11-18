#!/usr/bin/env bash
# cleanup-aws.sh
# Deletes AWS resources created for the CI/CD pipeline to prevent ongoing costs.

set -euo pipefail

if [ -z "${1:-}" ]; then
  echo "Usage: ./cleanup-aws.sh <S3_BUCKET_NAME>"
  echo "Example: ./cleanup-aws.sh aws-cicd-pipeline-app-1710000000"
  exit 1
fi

BUCKET_NAME="$1"

echo "=========================================="
echo " Cleaning Up AWS Resources"
echo "=========================================="
echo "Target S3 Bucket: ${BUCKET_NAME}"

read -r -p "Are you sure you want to delete '${BUCKET_NAME}' and ALL its files? [y/N]: " CONFIRM
if [[ ! "${CONFIRM}" =~ ^[Yy]$ ]]; then
  echo "Cleanup cancelled."
  exit 0
fi

# 1. Empty S3 Bucket
echo "Emptying bucket ${BUCKET_NAME}..."
aws s3 rm "s3://${BUCKET_NAME}" --recursive

# 2. Delete S3 Bucket
echo "Deleting bucket ${BUCKET_NAME}..."
aws s3api delete-bucket --bucket "${BUCKET_NAME}"

echo "=========================================="
echo " Cleanup complete! Resource successfully deleted."
echo "=========================================="
