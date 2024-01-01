#!/bin/bash
set -euo pipefail

doctl database create \
    --region sfo3 \
    --size db-s-1vcpu-1gb \
    --engine pg \
    --version 15 \
    papyrus-db

