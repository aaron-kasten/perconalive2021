PROFILE_NAME=$(kubectl get profiles -n kanister --no-headers -o jsonpath --template "{ .items[*].metadata.name }{ '\n' }")
ACTIONSET_NAME=$1
set -v
kanctl create actionset \
    --action restore \
    --from $ACTIONSET_NAME \
    --statefulset postgres/postgres-postgresql \
    --namespace kanister \
    --blueprint postgres-bp \
    --profile "kanister/$PROFILE_NAME"

