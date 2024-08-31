#!/bin/bash

# ---------------------------------------------------------------------------------------------------------------------
# NOTES
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------
#
#
# - Nginx server_name is set to $app_name.local (Laravel dir name + ".local")
#   - Make sure to add this to the "hosts" (windows) file to access the site via this address
#
# - $app_path -> /home/ubuntu/Dev-wsl/code/<app_name>
# - $app_name -> <app_name>
# - $laradock_name -> "laradock-$app_name" OR "$project_name" (input) laradock installation inside the <app_name>
# - $laradock_path -> "$app_path/$laradock_name" -> installation directory housed inside the <app_name>
# - $laradock_data_dir ->  ~/.laradock directory in WSL
# - $default_compose_project_name -> laradock .env (COMPOSE_PROJECT_NAME=); unique name for docker image
# - $default_compose_project_name -> laradock .env (COMPOSE_PROJECT_NAME=); unique name for docker image
#
#
#
# ---------------------------------------------------------------------------------------------------------------------
# ---------------------------------------------------------------------------------------------------------------------



# Defaultalues
php_version="8.3"
echo "Setting php_version to $php_version"



# /home/ubuntu/Dev-wsl/code/<app_name>
app_path=$(pwd) 

echo "Current DIR: $app_path\n"



if echo "$app_path" | grep -q "/api"; then
    # Get /project-name from /somedir/project-name/api
    app_name=$(basename $(dirname $app_path))
else 
    # Get /project-name from /somedir/project-name/
    app_name=$(basename $app_path)
fi

echo "app_name: $app_name"



# # Transform to kebab case
site_name=$(echo "$app_name" | sed 's/ /-/g')

echo "site_name: $site_name"



# Install Laradock inside a web-app
laradock_name="laradock-$site_name"

echo "laradock_name: $laradock_name"



# Set Laradock Directory Path (Inside the Laravel App)
laradock_path="$app_path/$laradock_name"

echo "laradock_path: $laradock_path"



git clone --depth 1 -b v16.0 git@github.com:laradock/laradock.git $laradock_name

echo "Cloned My-Laradock successfully!\n"



# Setup Laradock .env file
cp $laradock_path/.env.example $laradock_path/.env

echo "Generated .env file for $laradock_name ($app_path/$laradock_name)\n"



# Setup Laravel App's .env file
if [ ! -f "$app_path/.env" ]; then
    cp $app_path/.env.example $app_path/.env
    echo "Generated .env file for Laravel app: $app_name ($app_path)\n"
fi



# ====================
# SET PROJECT NAME
# ====================

# Set the default value for COMPOSE_PROJECT_NAME
echo "Setting $laradock_name as COMPOSE_PROJECT_NAME!\n"

# Update the COMPOSE_PROJECT_NAME variable in .env
sed -i "s#COMPOSE_PROJECT_NAME=.*#COMPOSE_PROJECT_NAME=$laradock_name#" $laradock_path/.env
sed -i "s#COMPOSE_PROJECT_NAME=.*#COMPOSE_PROJECT_NAME=$laradock_name#" $laradock_path/.env.example

echo "Done settting COMPOSE_PROJECT_NAME TO $laradock_name!\n"



# ================================================
# SET EXCLUSIVE DATA_PATH_HOST (~/.laradock/data)
#
#   Laradock Installation in /home/Ubuntu/
#   For 'volume' separation
# ================================================

# For storage exclusivity (/home/ubuntu/.laradock directory)
laradock_data_dir="~/.laradock/data/$laradock_name"

echo "Setting DATA_PATH_HOST for laradock volume storage exclusivity (~/.lardock/data/<project_name>)\n"

sed -i "s#DATA_PATH_HOST=.*#DATA_PATH_HOST=$laradock_data_dir#" $laradock_path/.env
sed -i "s#DATA_PATH_HOST=.*#DATA_PATH_HOST=$laradock_data_dir#" $laradock_path/.env.example

echo "Done setting DATA_PATH_HOST to $laradock_data_dir\n"



# ====================
# SET PHP VERSION 
# ====================

echo "Setting php_version to $php_version...\n"

# UPDATE PHP VERSION
sed -i "s#PHP_VERSION=.*#PHP_VERSION=$php_version#" $laradock_path/.env
sed -i "s#PHP_VERSION=.*#PHP_VERSION=$php_version#" $laradock_path/.env.example

echo "Done setting PHP_VERSION to $php_version!\n"



# =====================
# INSTALL PHP SERVICES
# =====================

# https://laradock.io/documentation/#install-php-extensions: PHP_FPM, WORKSPACE, PHP_WORKER
echo "Installing PHP services...\n"

sed -i "s#PHP_WORKER_INSTALL_BZ2=.*#PHP_WORKER_INSTALL_BZ2=true#" $laradock_path/.env
sed -i "s#PHP_WORKER_INSTALL_BZ2=.*#PHP_WORKER_INSTALL_BZ2=true#" $laradock_path/.env.example
sed -i "s#WORKSPACE_INSTALL_BZ2=.*#WORKSPACE_INSTALL_BZ2=true#" $laradock_path/.env
sed -i "s#WORKSPACE_INSTALL_BZ2=.*#WORKSPACE_INSTALL_BZ2=true#" $laradock_path/.env.example
sed -i "s#PHP_FPM_INSTALL_BZ2=.*#PHP_FPM_INSTALL_BZ2=true#" $laradock_path/.env
sed -i "s#PHP_FPM_INSTALL_BZ2=.*#PHP_FPM_INSTALL_BZ2=true#" $laradock_path/.env.example

sed -i "s#PHP_WORKER_INSTALL_ZIP_ARCHIVE=.*#PHP_WORKER_INSTALL_ZIP_ARCHIVE=true#" $laradock_path/.env
sed -i "s#PHP_WORKER_INSTALL_ZIP_ARCHIVE=.*#PHP_WORKER_INSTALL_ZIP_ARCHIVE=true#" $laradock_path/.env.example
sed -i "s#WORKSPACE_INSTALL_ZIP_ARCHIVE=.*#WORKSPACE_INSTALL_ZIP_ARCHIVE=true#" $laradock_path/.env
sed -i "s#WORKSPACE_INSTALL_ZIP_ARCHIVE=.*#WORKSPACE_INSTALL_ZIP_ARCHIVE=true#" $laradock_path/.env.example
sed -i "s#PHP_FPM_INSTALL_ZIP_ARCHIVE=.*#PHP_FPM_INSTALL_ZIP_ARCHIVE=true#" $laradock_path/.env
sed -i "s#PHP_FPM_INSTALL_ZIP_ARCHIVE=.*#PHP_FPM_INSTALL_ZIP_ARCHIVE=true#" $laradock_path/.env.example

sed -i "s#PHP_WORKER_INSTALL_SOAP=.*#PHP_WORKER_INSTALL_SOAP=true#" $laradock_path/.env
sed -i "s#PHP_WORKER_INSTALL_SOAP=.*#PHP_WORKER_INSTALL_SOAP=true#" $laradock_path/.env.example
sed -i "s#WORKSPACE_INSTALL_SOAP=.*#WORKSPACE_INSTALL_SOAP=true#" $laradock_path/.env
sed -i "s#WORKSPACE_INSTALL_SOAP=.*#WORKSPACE_INSTALL_SOAP=true#" $laradock_path/.env.example
sed -i "s#PHP_FPM_INSTALL_SOAP=.*#PHP_FPM_INSTALL_SOAP=true#" $laradock_path/.env
sed -i "s#PHP_FPM_INSTALL_SOAP=.*#PHP_FPM_INSTALL_SOAP=true#" $laradock_path/.env.example

# sed -i "s#PHP_WORKER_INSTALL_SWOOLE=.*#PHP_WORKER_INSTALL_SWOOLE=true#" $laradock_path/.env
# sed -i "s#PHP_WORKER_INSTALL_SWOOLE=.*#PHP_WORKER_INSTALL_SWOOLE=true#" $laradock_path/.env.example
# sed -i "s#WORKSPACE_INSTALL_SWOOLE=.*#WORKSPACE_INSTALL_SWOOLE=true#" $laradock_path/.env
# sed -i "s#WORKSPACE_INSTALL_SWOOLE=.*#WORKSPACE_INSTALL_SWOOLE=true#" $laradock_path/.env.example
# sed -i "s#PHP_FPM_INSTALL_SWOOLE=.*#PHP_FPM_INSTALL_SWOOLE=true#" $laradock_path/.env
# sed -i "s#PHP_FPM_INSTALL_SWOOLE=.*#PHP_FPM_INSTALL_SWOOLE=true#" $laradock_path/.env.example

echo "Done installing PHP services...\n"



# =============================
# INSTALL DEFAULT PHP SERVICES
# =============================

# ENABLE  PHP DECIMAL (support for correctly-rounded arithmetic vs float/string)
if [ -f "$laradock_path/.env" ]; then
    echo "Installing phpdecimal support...\n"

    sed -i "s#WORKSPACE_INSTALL_PHPDECIMAL=.*#WORKSPACE_INSTALL_PHPDECIMAL=true#" $laradock_path/.env
    sed -i "s#WORKSPACE_INSTALL_PHPDECIMAL=.*#WORKSPACE_INSTALL_PHPDECIMAL=true#" $laradock_path/.env.example
    sed -i "s#PHP_FPM_INSTALL_PHPDECIMAL=.*#PHP_FPM_INSTALL_PHPDECIMAL=true#" $laradock_path/.env
    sed -i "s#PHP_FPM_INSTALL_PHPDECIMAL=.*#PHP_FPM_INSTALL_PHPDECIMAL=true#" $laradock_path/.env.example

    echo "Done!\n"
else 
    echo "\n[=== NOTICE ===]: phpdecimal was not installed.\n\n"
fi



# ========================
# CREATE DEFAULT DATABASE
# ========================

# If Laravel .env is existing
if [ -f "$app_path/.env" ]; then
    echo "Creating default database script file (createdb.sql)...\n"

    # Create Database - Script
    create_database_sql_content='CREATE DATABASE IF NOT EXISTS `laravel` COLLATE 'utf8mb4_unicode_ci';\nGRANT ALL ON `laravel`.* TO 'default'@'%';\nFLUSH PRIVILEGES;'

    # Create Database - SQL file
    echo "$create_database_sql_content" > "$laradock_path/mysql/docker-entrypoint-initdb.d/createdb.sql"

    echo "Created new file: createdb.sql in $laradock_path/mysql/docker-entrypoint-initdb.d/ for database creation!\n"

    echo "Updating DB_ vars in Laravel app ($app_path/.env)...\n"

    # Update laravel .env database vars
    sed -i "s#DB_CONNECTION=.*#DB_CONNECTION=mysql#" $app_path/.env
    sed -i "s#DB_HOST=.*#DB_HOST=mysql#" $app_path/.env
    sed -i "s#DB_DATABASE=.*#DB_DATABASE=laravel#" $app_path/.env
    sed -i "s#DB_USERNAME=.*#DB_USERNAME=root#" $app_path/.env
    sed -i "s#DB_PASSWORD=.*#DB_PASSWORD=root#" $app_path/.env

    sed -i "s#DB_CONNECTION=.*#DB_CONNECTION=mysql#" $app_path/.env.example
    sed -i "s#DB_HOST=.*#DB_HOST=mysql#" $app_path/.env.example
    sed -i "s#DB_DATABASE=.*#DB_DATABASE=laravel#" $app_path/.env.example
    sed -i "s#DB_USERNAME=.*#DB_USERNAME=root#" $app_path/.env.example
    sed -i "s#DB_PASSWORD=.*#DB_PASSWORD=root#" $app_path/.env.example
    
    # Remove # if commented
    sed -i '/#DB_CONNECTION/s/^#//' $app_path/.env
    sed -i '/#DB_HOST/s/^#//' $app_path/.env
    sed -i '/#DB_DATABASE/s/^#//' $app_path/.env
    sed -i '/#DB_USERNAME/s/^#//' $app_path/.env
    sed -i '/#DB_PASSWORD/s/^#//' $app_path/.env

    sed -i '/#DB_CONNECTION/s/^#//' $app_path/.env.example
    sed -i '/#DB_HOST/s/^#//' $app_path/.env.example
    sed -i '/#DB_DATABASE/s/^#//' $app_path/.env.example
    sed -i '/#DB_USERNAME/s/^#//' $app_path/.env.example
    sed -i '/#DB_PASSWORD/s/^#//' $app_path/.env.example

    echo "Done updating DB_ vars in parent ($app_path/.env)!\n"
else 
    echo "\n[=== NOTICE ===]: Database(laravel) was not created for the Laravel Application.\n\n"
fi



# ===================
# INSTALL Node + NVM
# ===================

# If laradock .env is existing
if [ -f "$laradock_path/.env" ]; then
    echo "Installing Node + NVM...\n"

    sed -i "s#WORKSPACE_INSTALL_NODE=.*#WORKSPACE_INSTALL_NODE=true#" $laradock_path/.env
    sed -i "s#WORKSPACE_INSTALL_NODE=.*#WORKSPACE_INSTALL_NODE=true#" $laradock_path/.env.example

    sed -i "s#WORKSPACE_INSTALL_NPM_CHECK_UPDATES_CLI=.*#WORKSPACE_INSTALL_NPM_CHECK_UPDATES_CLI=true#" $laradock_path/.env
    sed -i "s#WORKSPACE_INSTALL_NPM_CHECK_UPDATES_CLI=.*#WORKSPACE_INSTALL_NPM_CHECK_UPDATES_CLI=true#" $laradock_path/.env.example

    echo "Updated .env vars that intalls Node + NVM!\n"
else 
    echo "\n[=== NOTICE ===]: Node + NVM was not installed.\n\n"
fi



# ===================
# INSTALL SUPERVISOR
# ===================

# Create Supervisord.d Config
supervisor_worker_file="$laradock_path/php-worker/supervisord.d/laravel-worker.conf"

if [ -f "$laradock_path/.env" ]; then
    echo "Setting up Queue workers via Supervisord\n"

    sed -i "s#WORKSPACE_INSTALL_SUPERVISOR=.*#WORKSPACE_INSTALL_SUPERVISOR=true#" $laradock_path/.env
    sed -i "s#WORKSPACE_INSTALL_SUPERVISOR=.*#WORKSPACE_INSTALL_SUPERVISOR=true#" $laradock_path/.env.example
    sed -i "s#WORKSPACE_INSTALL_PYTHON=.*#WORKSPACE_INSTALL_PYTHON=true#" $laradock_path/.env
    sed -i "s#WORKSPACE_INSTALL_PYTHON=.*#WORKSPACE_INSTALL_PYTHON=true#" $laradock_path/.env.example

    echo "Created supervisord conf file in: $supervisor_worker_file\n"

cat <<EOL > "$supervisor_worker_file"
[program:laravel-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/artisan queue:work --sleep=3 --tries=3
autostart=true
autorestart=true
numprocs=8
user=laradock
redirect_stderr=true

[program:scheduled-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/artisan queue:work --queue=scheduled --sleep=3 --tries=3
autostart=true
autorestart=true
numprocs=4
user=laradock
redirect_stderr=true

[program:heavy-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/artisan queue:work --queue=heavy --sleep=3 --tries=3
autostart=true
autorestart=true
numprocs=2
user=laradock
redirect_stderr=true

[program:emails-worker]
process_name=%(program_name)s_%(process_num)02d
command=php /var/www/artisan queue:work --queue=emails --sleep=3 --tries=3
autostart=true
autorestart=true
numprocs=2
user=laradock
redirect_stderr=true
EOL

    echo "Added workers to the .conf file!\n"
else 
    echo "\n[=== Notice ===]: Supervisor and queue workers were not created in $supervisor_worker_file.\n\n"
fi



# ==========================
# INSTALL OPTIONAL SERVICES
# ==========================

additional_commands=""
echo "Installing optional services!\n"
echo "Queue Worker\n"
echo "MySQL\n"
echo "phpMyAdmin\n"
echo "Redis\n"
echo "Mongo\n"
echo "Mailpit\n"

if [ -f "$app_path/.env" ]; then
    echo "Updating REDIS_ .env vars in parent ($app_path/.env)!\n"
    # Update Redis vars
    sed -i "s#REDIS_HOST=.*#REDIS_HOST=redis#" $app_path/.env
    sed -i "s#REDIS_HOST=.*#REDIS_HOST=redis#" $app_path/.env.example

    echo "Done!"
fi

if [ -f "$laradock_path/.env" ]; then
    echo "Updating MONGO .env vars in Laradock ($laradock_path/.env)"

    sed -i "s#WORKSPACE_INSTALL_MONGO=.*#WORKSPACE_INSTALL_MONGO=true#" $laradock_path/.env
    sed -i "s#WORKSPACE_INSTALL_MONGO=.*#WORKSPACE_INSTALL_MONGO=true#" $laradock_path/.env.example
    sed -i "s#PHP_FPM_INSTALL_MONGO =.*#PHP_FPM_INSTALL_MONGO =true#" $laradock_path/.env
    sed -i "s#PHP_FPM_INSTALL_MONGO =.*#PHP_FPM_INSTALL_MONGO =true#" $laradock_path/.env.example

    echo "Done!"
fi

if [ -f "$app_path/.env" ]; then
    # Back to Laravel App

    echo "Updating MAIL_ .env vars in parent ($app_name/.env) for Mailpit!\n"

    sed -i "s#MAIL_MAILER=.*#MAIL_MAILER=smtp#" $app_path/.env
    sed -i "s#MAIL_MAILER=.*#MAIL_MAILER=smtp#" $app_path/.env.example
    sed -i "s#MAIL_HOST=.*#MAIL_HOST=mailpit#" $app_path/.env
    sed -i "s#MAIL_HOST=.*#MAIL_HOST=mailpit#" $app_path/.env.example
    sed -i "s#MAIL_PORT=.*#MAIL_PORT=1125#" $app_path/.env
    sed -i "s#MAIL_PORT=.*#MAIL_PORT=1125#" $app_path/.env.example
    sed -i "s#MAIL_USERNAME=.*#MAIL_USERNAME=null#" $app_path/.env
    sed -i "s#MAIL_USERNAME=.*#MAIL_USERNAME=null#" $app_path/.env.example
    sed -i "s#MAIL_PASSWORD=.*#MAIL_PASSWORD=null#" $app_path/.env
    sed -i "s#MAIL_PASSWORD=.*#MAIL_PASSWORD=null#" $app_path/.env.example

    echo "Done!\n"
fi



# Append to alias for docker-compose command
additional_commands=" php-worker  mysql  phpmyadmin  redis  mongo  mailpit"

echo "Done installing additional (optional) services!\n"



# =======================
# Set Custom URL (LOCAL)
# =======================



# Create Config
sites_config_file="$laradock_path/nginx/sites/$site_name.conf"

# Check if ${laradock_name}.conf is existing
# if [ ! -f "$sites_config_file" ]; then
echo "Setting up NGINX config file in $site_config_file (Custom URL: $site_name.local)\n"



# Escape nginx default dynamic vars ($uri, $is_args) inside .conf file
uri='$uri'
is_args='$is_args'
args='$args'
document_root='$document_root'
fastcgi_script_name='$fastcgi_script_name'

cat <<EOL > "$sites_config_file"
server {

    listen 80;
    listen [::]:80;

    # For https
    # listen 443 ssl;
    # listen [::]:443 ssl ipv6only=on;
    # ssl_certificate /etc/nginx/ssl/default.crt;
    # ssl_certificate_key /etc/nginx/ssl/default.key;

    server_name $site_name.local;
    root /var/www/public;
    index index.php index.html index.htm;

    location / {
         try_files $uri $uri/ /index.php$is_args$args;
    }

    location ~ \.php$ {
        try_files $uri /index.php =404;
        fastcgi_pass php-upstream;
        fastcgi_index index.php;
        fastcgi_buffers 16 16k;
        fastcgi_buffer_size 32k;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        #fixes timeouts
        fastcgi_read_timeout 600;
        include fastcgi_params;
    }

    location ~ /\.ht {
        deny all;
    }

    location /.well-known/acme-challenge/ {
        root /var/www/letsencrypt/;
        log_not_found off;
    }

    error_log /var/log/nginx/laravel_error.log;
    access_log /var/log/nginx/laravel_access.log;
}
EOL

echo "Done!\n"



# ==========================
# Rename networks 
#  - docker-compose.yml
# ==========================

if [ -f "$laradock_path/docker-compose.yml" ]; then
    echo "Updating network names in $laradock_path/docker-compose.yml\n"
    # # Set network names
    # sed -i "s/^\s*backend.*:/  backend${app_name}:/" "$laradock_path/docker-compose.yml"
    # sed -i "s/^\s*frontend.*:/  frontend${app_name}:/" "$laradock_path/docker-compose.yml"
    # # Change network names in each services
    # sed -i -E "s/^\s*- backend.*$/        - backend${app_name}/g" "$laradock_path/docker-compose.yml"
    # sed -i -E "s/^\s*- frontend.*$/        - frontend${app_name}/g" "$laradock_path/docker-compose.yml"

    # replace [any_spaces]backend[any_chars][colon] with "backend$app_name"
    sed -i -E 's/^([[:space:]]*)backend(\s*|-|.*)/\1backend-'"$app_name":'/g' "$laradock_path/docker-compose.yml"
    sed -i -E 's/^([[:space:]]*)backend(\s*|-|.*)/\1backend-'"$app_name":'/g' "$laradock_path/docker-compose.yml"
    # Replace line: [any_spaces]backend[any_chars] with "- backend$app_name"
    sed -i -E 's/^([[:space:]]*)- backend(\s*|-|.*)/\1- backend-'"$app_name"'/g' "$laradock_path/docker-compose.yml"
    sed -i -E 's/^([[:space:]]*)- backend(\s*|-|.*)/\1- backend-'"$app_name"'/g' "$laradock_path/docker-compose.yml"

    echo "Done!\n"
else
    echo "\n[=== WARNING ===]: Failed to update docker-compose.yml. File not found in $laradock_path.\n\n"
fi



# ============================
# FINALIZE: Rebuild Container
# ============================

# Rebuild the container
echo "\nBuilding workspace, php-fpm and php-worker...\n"
docker-compose build workspace php-fpm php-worker

# Building the services
echo "\nBuilding the services ($additional_commands)...\n"
docker-compose build nginx $additional_commands

echo "\nDocker container has been built successfully!\n"



# ===================
# ADD ALIAS in WSL
# ===================

echo "\nAdding aliases for docker commands...\n"



# ==============================================
# Alias for starting the apps' docker container
# ==============================================

echo "\n" >> ~/.bashrc

alias="up"
command="docker-compose up -d nginx $additional_commands"

echo "Adding action: $alias with command: $command to ~/.bashrc\n"

# Check if the alias is defined in ~/.bashrc
if grep -q "alias $alias=" ~/.bashrc; then
    echo "Alias '$alias' is already defined in ~/.bashrc.\n"
else
    # Edit the bash configuration file to add the alias
    echo "alias $alias=\"$command\"" >> ~/.bashrc

    # Apply the current changes to current shell instance
    . ~/.bashrc # . (dot) instead of 'source' since this is executed from a file

    echo "Done!\n"
fi

echo "Adding action: $alias with command: $command to ~/.zshrc\n"
if grep -q "alias $alias=" ~/.zshrc; then
    echo "Alias '$alias' is already defined in ~/.zshrc.\n"
else
    # Edit the bash configuration file to add the alias
    echo "alias $alias=\"$command\"" >> ~/.zshrc

    # Apply the current changes to current shell instance
    . ~/.zshrc # . (dot) instead of 'source' since this is executed from a file

    echo "Done!\n"
fi



# ==============================================
# Alias for stopping the app's docker container
# ==============================================

alias="stop"
command="docker-compose stop"

echo "Adding action: $alias with command: $command to ~/.bashrc\n"

# Check if the alias is defined in ~/.bashrc
if grep -q "alias $alias=" ~/.bashrc; then
    echo "Alias '$alias' is already defined in ~/.bashrc\n"
else
    # Edit the bash configuration file to add the alias
    echo "alias $alias=\"$command\"" >> ~/.bashrc

    # Apply the current changes to current shell instance
    . ~/.bashrc # . (dot) instead of 'source' since this is executed from a file

    echo "Done!\n"
fi

echo "Adding action: $alias with command: $command to ~/.zshrc\n"
if grep -q "alias $alias=" ~/.zshrc; then
    echo "Alias '$alias' is already defined in ~/.zshrc\n"
else
    # Edit the bash configuration file to add the alias
    echo "alias $alias=\"$command\"" >> ~/.zshrc

    # Apply the current changes to current shell instance
    . ~/.zshrc # . (dot) instead of 'source' since this is executed from a file

    echo "Done!\n"
fi



# ===================================================
# Alias for Entering the container's workspace shell
# - App's shell (run artisan commands here...)
# ===================================================

alias="workspace"
command="docker-compose exec -it --user=laradock workspace bash"

echo "Adding alias: $alias with command: $command to ~/.bashrc\n"

# Check if the alias is defined in ~/.bashrc
if grep -q "alias $alias=" ~/.bashrc; then
    echo "Alias '$alias' is already defined in ~/.bashrc.\n"
else
    # Edit the bash configuration file to add the alias
    echo "alias $alias=\"$command\"" >> ~/.bashrc

    # Apply the current changes to current shell instance
    . ~/.bashrc # . (dot) instead of 'source' since this is executed from a file

    echo "Done!\n"
fi

echo "Adding action: $alias with command: $command to ~/.zshrc\n"
if grep -q "alias $alias=" ~/.zshrc; then
    echo "Alias '$alias' is already defined in ~/.zshrc.\n"
else
    # Edit the bash configuration file to add the alias
    echo "alias $alias=\"$command\"" >> ~/.zshrc

    # Apply the current changes to current shell instance
    . ~/.zshrc # . (dot) instead of 'source' since this is executed from a file

    echo "Done!\n"
fi



# ==================================
# Initialize the App
# ==================================
# 
# - Install packages
#   - via Composer
#   - via NPM
# - Generate Key
# - Create DB
# - Migrate DB
# - Set local directory permissions
# 
# ==================================

# Export all variables into init-laravel-app.sh
# export -p
export app_path 
export site_name

echo "init-laravel-app.sh inside"

echo "$app_path/laradock-$site_name"

sh ./init-laravel-app.sh






# ===================================================
# CLEANUP
# ===================================================

# Remove install scripts 
# rm ./installer.sh

# rm ./init-laravel-app.sh






# ===================
# DONE !!!
# ===================

echo "\n\n[RESULT]: Done setting up Laradock!\n\n"