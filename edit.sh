#!/bin/sh

sed "s/\$UUID/${UUID}/g" /root/config.json
sed "s/\$PORT/${PORT}/g" /root/nginx.conf
