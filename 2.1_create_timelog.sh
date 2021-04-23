set -v
kubectl create namespace timelogger
cat <<EOF | kubectl create -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: time-logger
  namespace: timelogger
spec:
  selector:
    matchLabels:
      app: time-logger
  replicas: 1
  template:
    metadata:
      labels:
        app: time-logger
    spec:
      containers:
      - name: test-container
        image: "ghcr.io/kanisterio/kanister-tools:0.50.0"
        command: ["sh", "-c"]
        args: ["while true; do for x in \$(seq 1200); do date >> /var/log/time.log; sleep 1; done; truncate --size 0 /var/log/time.log; done"]
EOF

