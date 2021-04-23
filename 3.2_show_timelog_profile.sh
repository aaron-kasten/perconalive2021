PROFILE_NAME=$(kubectl get profiles -n kanister --no-headers -o jsonpath --template "{ .items[*].metadata.name }{ '\n' }")
set -v
kubectl get profiles -n kanister $PROFILE_NAME -o yaml
