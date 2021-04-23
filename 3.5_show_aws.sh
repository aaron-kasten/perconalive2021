set -v
aws s3 ls s3://$AWS_BUCKET/timelogger
aws s3 cp s3://$AWS_BUCKET/timelogger - | tail
