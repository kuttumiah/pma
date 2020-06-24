#!/bin/bash

LATEST_VERSION=$(curl -sS 'https://api.github.com/repos/phpmyadmin/phpmyadmin/releases/latest' | awk -F '"' '/tag_name/{print $4}')
DOWNLOAD_URL="https://api.github.com/repos/phpmyadmin/phpmyadmin/tarball/${LATEST_VERSION}"

echo "Downloading phpMyAdmin ${LATEST_VERSION}"
wget $DOWNLOAD_URL -q --show-progress -O 'phpmyadmin.tar.gz'

mkdir phpmyadmin && tar xf phpmyadmin.tar.gz -C phpmyadmin --strip-components 1

rm phpmyadmin.tar.gz

CMD=/vagrant/scripts/site-types/laravel.sh
CMD_CERT=/vagrant/scripts/create-certificate.sh
PMACONFIGFILE="$(pwd)/phpmyadmin/config.inc.php"
RANDOMBLOWFISHSECRET=$(openssl rand -base64 32)

if [[ ! -f $CMD ]]; then
    # Fallback for older Homestead versions
    CMD=/vagrant/scripts/serve.sh
else
    # Create an SSL certificate
    sudo bash $CMD_CERT phpmyadmin.test
fi

sudo bash $CMD phpmyadmin.test $(pwd)/phpmyadmin 80 443 7.3

echo "Installing dependencies for phpMyAdmin"
cd phpmyadmin && composer update --no-dev && yarn

echo 'Creating a new config.inc.php file...'
cp "$(pwd)/config.sample.inc.php" $PMACONFIGFILE

# setup blowfish
sed -i -e "/blowfish_secret/ s:=.*:= '${RANDOMBLOWFISHSECRET}';:" $PMACONFIGFILE

sudo service nginx reload
