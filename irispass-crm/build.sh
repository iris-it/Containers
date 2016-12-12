#!/bin/sh

# Prepare and go to directory
rm -rf /var/www/*
mkdir /var/www/app
cd /var/www/app

# Fetch the repository
git clone ${APP_REPOSITORY} .

# Delete git's files
find . -name ".git*" -exec rm -R {} \;

# Install PHP dependencies
composer install --no-interaction --no-dev --no-progress --profile --prefer-dist -vvv

# Install global Javascript dependencies
npm install -g gulp yarn

# Install Javascript dependencies with yarn ( faster )
yarn

# Build the assets
gulp --production