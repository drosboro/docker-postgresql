#!/bin/bash

echo "Updating postgresql.conf to allow for streaming replication"
cat >>${PGDATA}/postgresql.conf <<EOF
wal_level = replica
max_wal_senders = 2
max_replication_slots = 2
log_timezone = 'America/Vancouver'
timezone = 'America/Vancouver'
EOF