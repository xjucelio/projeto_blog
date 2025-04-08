#!/bin/sh
set -e

echo "Waiting for PostgreSQL..."
while ! nc -z psql 5432; do
  sleep 1
done
echo "✅ PostgreSQL is up!"

# Run migrations and start Django
python manage.py collectstatic --noinput
python manage.py makemigrations --noinput
python manage.py migrate --noinput
exec python manage.py runserver 0.0.0.0:8000