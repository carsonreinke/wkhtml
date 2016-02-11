#!/bin/sh

wget http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz > /dev/null
tar xf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
echo "wkhtmltopdf: `./wkhtmltox/bin/wkhtmltopdf -V`"
echo "wkhtmltoimage: `./wkhtmltox/bin/wkhtmltoimage -V`"

bundle install
bundle exec rake compile -- --with-wkhtmltox-dir=./wkhtmltox/