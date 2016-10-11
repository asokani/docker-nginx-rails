#!/bin/bash

if [ -a /var/run/unicorn.pid ]
then
	/usr/bin/sv 2 unicorn
fi