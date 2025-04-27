#!/bin/sh
set -e

# Set up environment for Chromium to run in headless mode within a container
export CHROME_PATH=/usr/bin/chromium
export CHROME_BIN=/usr/bin/chromium
export CHROME_NO_SANDBOX=true
export CHROMIUM_FLAGS="--headless --disable-gpu --no-sandbox --disable-dev-shm-usage"

# Ensure thumbnails directories exist with proper permissions
mkdir -p /app/_build/prod/lib/uptimer/priv/static/uploads/thumbnails
mkdir -p /app/priv/static/uploads

# Create thumbnail directories with proper permissions
chown -R nobody:root /app/priv/static
chown -R nobody:root /app/_build/prod/lib/uptimer/priv/static

# No need to remove or create symlink for volumes - just create symbolic link if it doesn't exist
if [ ! -L /app/priv/static/uploads/thumbnails ]; then
  # Create a symbolic link only if it doesn't already exist
  ln -sf /app/_build/prod/lib/uptimer/priv/static/uploads/thumbnails /app/priv/static/uploads/thumbnails
fi

# Wait for the database to be ready (optional but recommended)
# Add sleep or other database connection check if needed

# Run migrations
/app/bin/migrate

# Execute the command provided as arguments
exec "$@" 