#!/bin/bash

DB_HOST="postgis"
DB_PORT=5432
DB_USER="gis"
DB_NAME="gis"

until psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -lqt | grep -qw "$DB_NAME"
do
    echo "Waiting for postgis ready..."
    sleep 2
done

# check for existing data
psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
    -c "SELECT 'exists' FROM information_schema.tables WHERE table_name='planet_osm_point';" \
    | grep -qw exists

# and only import osm.pbf files if there was none
if [ $? -ne 0 ]; then
    osm2pgsql -H "$DB_HOST" -P "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
              --slim -G --hstore --create \
              --tag-transform-script /gis/openstreetmap-carto/openstreetmap-carto.lua \
              --style /gis/openstreetmap-carto/openstreetmap-carto.style \
              /data/*.osm.pbf
fi

apachectl start
renderd -f -c /usr/local/etc/renderd.conf
