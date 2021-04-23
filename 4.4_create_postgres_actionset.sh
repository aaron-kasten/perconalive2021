PROFILE_NAME=$(kubectl get profiles -n kanister --no-headers -o jsonpath --template "{ .items[*].metadata.name }{ '\n' }")
set -v
kanctl create actionset \
    --action backup \
    --statefulset postgres/postgres-postgresql \
    --namespace kanister \
    --blueprint postgres-bp \
    --profile "kanister/$PROFILE_NAME"

