set -v
export POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

cat <<EOF | kubectl run postgres-postgresql-client -i --rm --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:11.11.0-debian-10-r54 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-postgresql -U postgres -d example -p 5432

SELECT * FROM links;

\q
EOF

