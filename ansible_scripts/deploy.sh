#! /bin/bash

ansible-playbook $2.yml -u $1 --ask-pass --ask-become-pass --extra-vars "host=$2-$3, catalogue=$4"
