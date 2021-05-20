#!/bin/bash
set -e

# create tables
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
CREATE TABLE IF NOT EXISTS shopping_list (
    id serial PRIMARY KEY,
    item varchar(255) NOT NULL,
    quantity smallint NOT NULL DEFAULT 1
);
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
INSERT INTO shopping_list (item, quantity) VALUES 
('celery', DEFAULT),
('carrots', DEFAULT),
('apples',7);
EOSQL