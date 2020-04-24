#!/bin/bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
mkdir -p /bpldc_authority_api-app/tmp/pids

rm -f /bpldc_authority_api-app/tmp/pids/server.pid
rm -f /bpldc_authority_api-app/tmp/pids/server.state
# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"

# based on instructions here: https://docs.docker.com/compose/rails/
