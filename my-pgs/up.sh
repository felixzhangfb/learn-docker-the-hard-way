#!/bin/sh
set -e

if [ ! -f ".env" ]; then
  cp .env.example .env
fi

chmod +x ./primary/*.sh
chmod +x ./replica/*.sh

docker compose up -d
