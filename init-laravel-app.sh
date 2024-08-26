#!/bin/bash



# ==================
# Composer Install
# ==================

echo "Installing composer packages..."

docker-compose exec workspace bash -c 'composer install'

echo "Done installing composer packages!"



# ==================
# Generate APP KEY
# ==================
ENV_FILE="$app_path/.env"

# Check if the .env file exists
if [ -f "$ENV_FILE" ]; then
    # Check if APP_KEY is set with an empty value in the .env file
    if grep -q "^APP_KEY=$" "$ENV_FILE"; then
        echo "Generating secure application key..."
        docker-compose exec workspace bash -c 'php artisan key:generate'
        echo "Secure application key was set successfully!"
    fi
else
    echo " Failed to set a secure application key (.env file not found)"
fi



# ==================
# NPM Install
# ==================

echo "Installing node packages"

docker-compose exec workspace bash -c 'npm install'

echo "Done installing node packages!"



# ==================
# Create Database
# Migrate and create database
# Using ENV vars set in docker-compose.yml from $laradock_path/.env file
# ==================

echo "Creating Database ${MYSQL_DATABASE} (if not yet created)..."

# Execute createdb.sql
docker-compose exec mysql bash -c 'mysql -u root -p${MYSQL_ROOT_PASSWORD} < /docker-entrypoint-initdb.d/createdb.sql'

echo "Done!"



# ====================================================
# DELETE the default contents of the storage folder
# ====================================================

# APPLY permissions to /storage - MUST NOT EXEC FOR PRODUCTION
docker-compose exec workspace bash -c "chmod -R 777 ./storage"


# ======================
# Migrate the database
# ======================

echo "Migrating the database..."

docker-compose exec workspace bash -c 'php artisan migrate --seed'

# echo  "Seeding the database with default seeders..."

# docker-compose exec workspace bash -c 'php artisan db:seed'

echo 'Done migrating the database!'






echo "\n\nAnd.... we're done! Thank you.\n"