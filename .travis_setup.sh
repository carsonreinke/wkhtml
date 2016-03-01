#!/bin/sh

wget -q http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz -O /tmp/wkhtmltox.tar.xz
tar -xf /tmp/wkhtmltox.tar.xz -C /tmp
echo "wkhtmltopdf: `/tmp/wkhtmltox/bin/wkhtmltopdf -V`"
echo "wkhtmltoimage: `/tmp/wkhtmltox/bin/wkhtmltoimage -V`"

bundle install --jobs=3 --retry=3
bundle exec rake compile -- --with-wkhtmltox-dir=/tmp/wkhtmltox --with-wkhtmltox-lib=/tmp/wkhtmltox/lib