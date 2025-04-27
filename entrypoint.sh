#!/bin/sh
set -e

# Set up environment for Chromium to run in headless mode within a container
export CHROME_PATH=/usr/bin/chromium
export CHROME_BIN=/usr/bin/chromium
export CHROME_NO_SANDBOX=true
export CHROMIUM_FLAGS="--headless --disable-gpu --no-sandbox --disable-dev-shm-usage"

# Wait for the database to be ready (optional but recommended)
# Add sleep or other database connection check if needed

# Run migrations
/app/bin/migrate

# Execute the command provided as arguments
exec "$@" 