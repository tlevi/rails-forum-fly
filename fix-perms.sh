#!/usr/bin/env bash

cd $(dirname $0)

sudo find ./app -type d -path ./app/tmp -prune -o -user root -exec chown -c $USER:$(id -g $USER) {} \;
