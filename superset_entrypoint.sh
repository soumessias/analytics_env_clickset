#!/bin/sh
set -e

# Set admin user variables with defaults
ADMIN_USERNAME="${SUPERSET_ADMIN_USERNAME:-admin}"
ADMIN_PASSWORD="${SUPERSET_ADMIN_PASSWORD:-admin}"
ADMIN_EMAIL="${SUPERSET_ADMIN_EMAIL:-admin@superset.com}"
ADMIN_FIRSTNAME="${SUPERSET_ADMIN_FIRSTNAME:-Superset}"
ADMIN_LASTNAME="${SUPERSET_ADMIN_LASTNAME:-Admin}"

# Set ClickHouse SQLAlchemy URI with default
CLICKHOUSE_URI="${CLICKHOUSE_SQLALCHEMY_URI:-clickhouse+http://default:default@clickhouse:8123/}"

# Create admin user if not exists
superset fab create-admin \
    --username "$ADMIN_USERNAME" \
    --firstname "$ADMIN_FIRSTNAME" \
    --lastname "$ADMIN_LASTNAME" \
    --email "$ADMIN_EMAIL" \
    --password "$ADMIN_PASSWORD" || true

# Start Superset in the background
superset db upgrade
superset init
superset run -h 0.0.0.0 -p 8088 &
SUP_PID=$!

# Wait for Superset to be ready
until curl -s http://localhost:8088/health | grep 'OK'; do
  echo "Waiting for Superset to be ready..."
  sleep 5
done

# Register ClickHouse database connection (idempotent)
superset set-database-uri \
  --database_name clickhouse \
  --uri "$CLICKHOUSE_URI"

# Wait for Superset process
wait $SUP_PID 