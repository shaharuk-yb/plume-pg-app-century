#!/bin/bash

# cleanup directories
rm -rf data
rm -rf migrations
rm -rf search_index

# recreate directories
mkdir -p data/plume/static/media
mkdir -p data/postgres/
mkdir -p search_index
mkdir -p migrations/postgres

# docker-compose up -d
