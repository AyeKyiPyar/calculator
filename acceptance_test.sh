#!/bin/bash
set -e

SERVER=$1

echo "Running acceptance test..."

PORT=$(ssh -o StrictHostKeyChecking=no ubuntu@$SERVER \
"docker-compose port calculator 8080 | cut -d: -f2")

URL="http://$SERVER:$PORT"

echo "Testing URL: $URL"

mvn verify -Dcalculator.url=$URL
$CALCULATOR_PORT
