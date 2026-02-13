#!/bin/bash

echo "================================="
echo " Running Acceptance Test"
echo "================================="

# Run against localhost
PORT=$(docker ps --filter name=akps-calculator-container --format '{{.Ports}}' | sed -n 's/.*:\([0-9]*\)->8080.*/\1/p')

if [ -z "$PORT" ]; then
  echo "❌ Container port not found"
  exit 1
fi

echo "Calculator running at http://localhost:$PORT"

# Wait for app startup
sleep 10

# Run Maven tests
mvn test -Dcalculator.url=http://localhost:$PORT
