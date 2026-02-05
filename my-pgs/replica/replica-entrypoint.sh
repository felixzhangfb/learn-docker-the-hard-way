#!/bin/sh
set -e

MAX_WAIT=60   # seconds
WAITED=0
INTERVAL=2

until pg_isready -h pg-primary -U "${REPLICA_USER}"; do
  if [ "${WAITED}" -ge "${MAX_WAIT}" ]; then
    echo "ERROR: pg-primary not ready after ${MAX_WAIT}s"
    exit 1
  fi

  echo "Waiting for pg-primary to be ready... (${WAITED}s)"
  sleep "${INTERVAL}"
  WAITED=$((WAITED + INTERVAL))
done

echo "pg-primary is ready, starting replica..."

if [ ! -s "$PGDATA/PG_VERSION" ]; then
  PGPASSWORD="${REPLICA_PASSWORD}" \
    gosu postgres pg_basebackup \
      --host=pg-primary \
      --port="${PG_PRIMARY_PORT}" \
      --username="${REPLICA_USER}" \
      --pgdata="${PGDATA}" \
      --format=plain \
      --wal-method=stream \
      --write-recovery-conf \
      --progress

  echo "replica started successfully"
fi

exec gosu postgres postgres
