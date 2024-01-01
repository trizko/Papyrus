#!/bin/bash
set -euo pipefail

DB_ID=$(doctl databases list | grep papyrus-db | awk '{print $1}')

doctl databases delete --force $DB_ID