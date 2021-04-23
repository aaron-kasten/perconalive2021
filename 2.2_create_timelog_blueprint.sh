set -v
cat <<EOF | kubectl create -f -
apiVersion: cr.kanister.io/v1alpha1
kind: Blueprint
metadata:
  name: timelog-bp
  namespace: kanister
actions:
  backup:
    type: Deployment
    phases:
    - func: KubeExec
      name: backupToS3
      args:
        namespace: "{{ .Deployment.Namespace }}"
        pod: "{{ index .Deployment.Pods 0 }}"
        container: test-container
        command:
        - sh
        - -c
        - cat /var/log/time.log
EOF

