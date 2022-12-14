#!/usr/bin/env bash

PROJECT_PATH="$(pwd)"

echo "currently in $PROJECT_PATH"

cd "$PROJECT_PATH/magento"

/usr/local/bin/composer install --dry-run --prefer-dist --no-progress &> /dev/null

COMPOSER_COMPATIBILITY=$?

echo "Composer compatibility: $COMPOSER_COMPATIBILITY"


set -e

if [ $COMPOSER_COMPATIBILITY = 0 ]
then
	/usr/local/bin/composer install --prefer-dist --no-progress
else
  echo "using composer v1"
  php7.2 /usr/local/bin/composer self-update --1
	/usr/local/bin/composer install --prefer-dist --no-progress
fi

chmod +x bin/magento

if [ $INPUT_ELASTICSUITE = 1 ]
then
  yes | cp -rf /opt/config/integration-test-config-esuite.php dev/tests/integration/etc/install-config-mysql.php
elif [ $INPUT_ELASTICSEARCH = 1 ]
then
  yes | cp -rf /opt/config/integration-test-config-es.php dev/tests/integration/etc/install-config-mysql.php
else
  yes | cp -rf /opt/config/integration-test-config.php dev/tests/integration/etc/install-config-mysql.php
fi

cd dev/tests/integration && ../../../vendor/bin/phpunit -c phpunit.xml.dist
