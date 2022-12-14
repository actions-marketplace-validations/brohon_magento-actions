#!/bin/sh -l

echo "hello your setup is $INPUT_PHP (PHP Version) & $INPUT_PROCESS  (Input Process) & $INPUT_OVERRIDE_SETTINGS (Settings Override)"


if [ $INPUT_PHP = 'auto' ]
then
  bash /opt/config/utils/php-compatibility-checker.sh
else
  echo "Forcing php to match specified php inputs argument"
  update-alternatives --set php /usr/bin/php${INPUT_PHP}
fi

if [ $INPUT_OVERRIDE_SETTINGS = 1 ]
then
  [ -d config ] && ls ./config/*
  [ -d scripts ] && ls ./scripts/*
  [ -d config ] && cp -rf ./config/* /opt/config/
  [ -d scripts ] && cp -rf ./scripts/* /opt/scripts/
  bash /opt/scripts/${INPUT_PROCESS}.sh
else
  bash /opt/scripts/${INPUT_PROCESS}.sh
fi