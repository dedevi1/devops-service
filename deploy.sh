#!/bin/bash
set -euo pipefail

IMAGE_NEW="${1:-ghcr.io/dedevi1/devops-service:latest}"
IMAGE_OLD="${2:-ghcr.io/dedevi1/devops-service:v0.0.1}"
NAME="svc"
PORT="8080"

health() {
  curl -fsS "http://localhost:${PORT}/health" >/dev/null
}

echo "Deploy: $IMAGE_NEW"
docker rm -f "$NAME" 2>/dev/null || true
docker run -d --name "$NAME" -p ${PORT}:8080 "$IMAGE_NEW" >/dev/null

echo "Checking health..."
for i in {1..10}; do
  if health; then
    echo "OK -> deployed $IMAGE_NEW"
    exit 0
  fi
  sleep 1
done

echo "Health failed -> rollback to $IMAGE_OLD"
docker rm -f "$NAME" 2>/dev/null || true
docker run -d --name "$NAME" -p ${PORT}:8080 "$IMAGE_OLD" >/dev/null
health && echo "Rollback OK" || (echo "Rollback failed" && exit 2)
