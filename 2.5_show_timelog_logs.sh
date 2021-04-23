POD_NAME=$(kubectl get pods -n kanister --no-headers -o jsonpath --template "{ .items[*].metadata.name }{ '\n' }")
set -v
kubectl logs -n kanister $POD_NAME | grep 'msg="Pod Update"' | grep -E -o 'Out=["][^"]+["]'
