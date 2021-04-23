set -v
kanctl create profile s3compliant \
    --access-key $AWS_ACCESS_KEY_ID \
    --secret-key $AWS_SECRET_ACCESS_KEY \
    --bucket $AWS_BUCKET --region $AWS_REGION \
    --namespace kanister

