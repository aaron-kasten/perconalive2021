set -v
POSTGRES_PASSWORD=$(kubectl get secret --namespace postgres postgres-postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)

cat <<EOF | kubectl run postgres-postgresql-client -i --rm --restart='Never' --namespace postgres --image docker.io/bitnami/postgresql:11.11.0-debian-10-r54 --env="PGPASSWORD=$POSTGRES_PASSWORD" --command -- psql --host postgres-postgresql -U postgres -d postgres -p 5432

CREATE DATABASE example;

\c example

DROP TABLE IF EXISTS links;

CREATE TABLE links (
	id SERIAL PRIMARY KEY,
	url VARCHAR(255) NOT NULL,
	name VARCHAR(255) NOT NULL,
	description VARCHAR (255),
        last_update DATE
);

INSERT INTO links (url, name) VALUES('https://www.postgresqltutorial.com','PostgreSQL Tutorial');
INSERT INTO links (url, name) VALUES('http://www.oreilly.com','O''Reilly Media');
INSERT INTO links (url, name) VALUES('http://www.postgresql.org','PostgreSQL');

\q
EOF

