#!/bin/bash
set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
DELETE FROM shopping_list;
EOSQL

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
INSERT INTO shopping_list (item, quantity) VALUES 
('celery', DEFAULT),
('carrots', DEFAULT),
('apples',7);
EOSQL