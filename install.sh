#!/usr/bin/env sh

echo "linking nest to /usr/local directory"
pushd `dirname $0` > /dev/null
ln -Fis "$(pwd)/" /usr/local/nest
ln -Fis /usr/local/nest/nest.conf /usr/local/etc/nest.conf
popd > /dev/null
