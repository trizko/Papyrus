#!/bin/bash
set -euo pipefail

# always run from the root of this repository
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

DB_ID=$(doctl databases list | grep papyrus-db | awk '{print $1}')
DB_DATA_JSON=$(doctl databases get $DB_ID --output json)
PG_PUBLIC_URI=$(echo $DB_DATA_JSON | jq -r .[].connection.uri)
PG_PRIVATE_URI=$(echo $DB_DATA_JSON | jq -r .[].private_connection.uri)

psql $PG_PUBLIC_URI -a -f ./server/db/init.sql