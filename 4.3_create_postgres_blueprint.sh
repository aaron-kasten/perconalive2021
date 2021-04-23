set -v
cat <<EOF | kubectl create -n kanister -f -
apiVersion: cr.kanister.io/v1alpha1
kind: Blueprint
metadata:
  name: postgres-bp
actions:
  backup:
    kind: StatefulSet
    outputArtifacts:
      cloudObject:
        keyValue:
          backupLocation: "{{ .Phases.pgDump.Output.backupLocation }}"
    phases:
    - func: KubeTask
      name: pgDump
      objects:
        pgSecret:
          kind: Secret
          name: '{{ index .Object.metadata.labels "app.kubernetes.io/instance" }}-postgresql'
          namespace: '{{ .StatefulSet.Namespace }}'
      args:
        image: ghcr.io/kanisterio/postgres-kanister-tools:0.50.0
        namespace: '{{ .StatefulSet.Namespace }}'
        command:
        - bash
        - -c
        - |
          set -o pipefail
          set -o errexit
          export PGHOST='{{ index .Object.metadata.labels "app.kubernetes.io/instance" }}-postgresql.{{ .StatefulSet.Namespace }}.svc.cluster.local'
          export PGUSER='postgres'
          export PGPASSWORD='{{ index .Phases.pgDump.Secrets.pgSecret.Data "postgresql-password" | toString }}'
          BACKUP_LOCATION=pg_backups/{{ .StatefulSet.Namespace }}/{{ .StatefulSet.Name }}/{{ toDate "2006-01-02T15:04:05.999999999Z07:00" .Time | date "2006-01-02T15:04:05Z07:00" }}/backup.sql.gz
          pg_dumpall --clean -U \$PGUSER | gzip -c | kando location push --profile '{{ toJson .Profile }}' --path "\${BACKUP_LOCATION}" -
          kando output backupLocation "\${BACKUP_LOCATION}"
  restore:
    kind: StatefulSet
    inputArtifactNames:
    - cloudObject
    phases:
    - func: KubeTask
      name: pgRestore
      objects:
        pgSecret:
          kind: Secret
          name: '{{ index .Object.metadata.labels "app.kubernetes.io/instance" }}-postgresql'
          namespace: '{{ .StatefulSet.Namespace }}'
      args:
        image: ghcr.io/kanisterio/postgres-kanister-tools:0.50.0
        namespace: '{{ .StatefulSet.Namespace }}'
        command:
        - bash
        - -c
        - |
          set -o pipefail
          set -o errexit
          export PGHOST='{{ index .Object.metadata.labels "app.kubernetes.io/instance" }}-postgresql.{{ .StatefulSet.Namespace }}.svc.cluster.local'
          export PGUSER='postgres'
          export PGPASSWORD='{{ index .Phases.pgRestore.Secrets.pgSecret.Data "postgresql-password" | toString }}'
          BACKUP_LOCATION={{ .ArtifactsIn.cloudObject.KeyValue.backupLocation }}
          kando location pull --profile '{{ toJson .Profile }}' --path "\${BACKUP_LOCATION}" - | gunzip -c -f | psql -q -U "\${PGUSER}"
  delete:
    type: Namespace
    inputArtifactNames:
      - cloudObject
    phases:
    - func: KubeTask
      name: deleteDump
      args:
        image: ghcr.io/kanisterio/postgres-kanister-tools:0.50.0
        namespace: "{{ .Namespace.Name }}"
        command:
          - bash
          - -c
          - |
            set -o pipefail
            set -o errexit
            kando location delete --profile '{{ toJson .Profile }}' --path '{{ .ArtifactsIn.cloudObject.KeyValue.backupLocation }}'
EOF
