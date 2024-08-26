# My Laradock 

Installer script for automating [Laradock](https://github.com/Laradock/laradock) installation.



## Table of Contents

- [Installation](#installation)
- [Notes](#notes)



## Installation

1. Copy the `.sh` files in the root of your Laravel application.
    - `installer.sh`
    - `init-laravel-app.sh`

2. Execute `installer.sh`

```bash  

sh installer.sh

```

3. (optional) If on LOCAL and having directory permissions problem:

```bash

chmod -R 777 /storage

```



### Notes

The installer executes 2 files:

- `installer.sh` 

This file installs `my-laradock`, a custom copy of [Laradock](https://github.com/Laradock/laradock), including:
- Configuring basic services
- Generating site configurations
- Creating a new database
- Generating command alias
- Calling `init-laravel-app.sh`


- `init-laravel-app.sh`

This file is called by `installer.sh` and installs the following: 
- Installs composer dependencies 
- Installs node dependencies
- Creates a default database called "laravel" from `/docker-entrypoint-initdb.d/createdb.sql`
- Applies directory permissions (777) to `/storage/` directory and sub0i for local developement
- Migrates and seeds the database



---

`my-laradock` is a custom ccopy of Laradock which purpose is to have a *consistent* local docker (Laradock) development environment.



