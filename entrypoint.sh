#!/bin/sh
set -e

# Wait for the database to be ready (optional but recommended)
# Add sleep or other database connection check if needed

# Run migrations
/app/bin/migrate

# Execute the command provided as arguments
exec "$@" 