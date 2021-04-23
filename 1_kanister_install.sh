set -v
kubectl create namespace kanister
helm repo add kanister https://charts.kanister.io
helm install kanister --namespace kanister kanister/kanister-operator --set image.tag=0.50.0

