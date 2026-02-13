#!/bin/bash

echo "================================="
echo " Running Acceptance Test"
echo "================================="

HOST=$1

if [ -z "$HOST" ]; then
  echo "❌ ERROR: Host not provided"
  exit 1
fi

echo "Target host: $HOST"

# Get exposed port of calculator container
PORT=$(ssh -o StrictHostKeyChecking=no ubuntu@$HOST \
"docker ps --filter name=akps-calculator-container --format '{{.Ports}}' | sed -n 's/.*:\([0-9]*\)->8080.*/\1/p'")

if [ -z "$PORT" ]; then
  echo "❌ ERROR: Container port not found"
  exit 1
fi

echo "Calculator running at http://$HOST:$PORT"

# Wait for app startup
echo "Waiting for service..."
sleep 10

# Run Maven acceptance tests
mvn test -Dcalculator.url=http://$HOST:$PORT

RESULT=$?

if [ $RESULT -ne 0 ]; then
  echo "❌ Acceptance tests FAILED"
  exit 1
else
  echo "✅ Acceptance tests PASSED"
fi
