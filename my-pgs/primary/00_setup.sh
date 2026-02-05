#!/bin/sh
set -e

echo "===== add replication access to pg_hba.conf ====="
printf "host replication %s 0.0.0.0/0 scram-sha-256\n" "${REPLICA_USER}" > "${PGDATA}/pg_hba_replicator.conf"
printf "\ninclude_if_exists pg_hba_replicator.conf\n" >> "${PGDATA}/pg_hba.conf"

echo "===== create replication user ====="
psql -v ON_ERROR_STOP=1 --username "${POSTGRES_USER}" -d "${POSTGRES_DB}" <<-EOSQL
    CREATE ROLE "${REPLICA_USER}" WITH REPLICATION LOGIN ENCRYPTED PASSWORD '${REPLICA_PASSWORD}';
EOSQL
