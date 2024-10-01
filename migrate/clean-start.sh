#!/bin/bash

# cleanup directories
rm -rf data
rm -rf migrations
rm -rf search_index

# recreate directories
mkdir -p data/plume/static/media
mkdir -p data/postgres/
mkdir -p data/yb_data/
mkdir -p search_index
mkdir -p migrations/postgres
mkdir -p migrations/yugabyte

# docker-compose up -d
