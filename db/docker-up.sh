#!/usr/bin/env bash

export PGPASSWORD="postgres"
PGHOST="localhost"
PGUSERNAME="postgres"
DBNAME="todo"

# start the docker container
[[ "$(docker ps -f name=postgresql --format '{{.State}}')" == "running" ]] || docker run -itd \
    -e POSTGRES_USER=$PGUSERNAME \
    -e POSTGRES_PASSWORD=$PGPASSWORD \
    -p 5432:5432 \
    --name postgresql \
    postgres:13.4-bullseye

sleep 5

# create the database
psql --quiet \
    --host=$PGHOST \
    --username=$PGUSERNAME \
    --command="CREATE DATABASE $DBNAME"

# run the schema scripts
psql \
    --host=$PGHOST \
    --username=$PGUSERNAME \
    --dbname=$DBNAME \
    --file=./db/schema/1_create_tables.sql
