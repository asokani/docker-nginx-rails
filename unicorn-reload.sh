#!/bin/bash
set -e
cd /var/app/current
exec bundle exec unicorn -c /var/app/current/config/unicorn.rb -E production

