#!/bin/sh

# Exit on any error
set -e

echo "Starting Truth Sandwich application..."

# Set default environment
export RACK_ENV=${RACK_ENV:-production}

echo "Environment: $RACK_ENV"
echo "Database URL: $DATABASE_URL"

# Wait for database file to be available (in case of mounted volumes)
sleep 2

# Check if database exists, if not create and migrate
if [ ! -f "db/production.sqlite3" ] && [ "$RACK_ENV" = "production" ]; then
    echo "Creating production database..."
    bundle exec rake db:create db:migrate db:seed RACK_ENV=production
elif [ ! -f "db/development.sqlite3" ] && [ "$RACK_ENV" = "development" ]; then
    echo "Creating development database..."
    bundle exec rake db:create db:migrate db:seed RACK_ENV=development
else
    echo "Database exists, running any pending migrations..."
    bundle exec rake db:migrate RACK_ENV=$RACK_ENV
fi

echo "Starting Puma server..."
exec "$@"
