set -v
cat <<EOF | kubectl create -f -
apiVersion: cr.kanister.io/v1alpha1
kind: ActionSet
metadata:
  generateName: backup-
  namespace: kanister
spec:
  actions:
  - name: backup
    blueprint: timelog-bp
    object:
      kind: Deployment
      name: time-logger
      namespace: timelogger
EOF

