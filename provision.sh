#!/bin/bash -x

apt-get update

useradd -u 1010 -s /bin/bash bodl-tei-svc
chown -R bodl-tei-svc:bodl-tei-svc /home/bodl-tei-svc
