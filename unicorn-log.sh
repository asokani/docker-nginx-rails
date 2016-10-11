#!/bin/sh
exec chpst -u www-user svlogd -tt /var/log/unicorn-run

