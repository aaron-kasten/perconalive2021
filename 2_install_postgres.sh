set -v
kubectl create namespace postgres
helm install postgres --namespace postgres bitnami/postgresql

