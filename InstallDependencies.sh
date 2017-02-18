#! /bin/bash
runas apt-get update
runas apt-get install nodejs
runas apt-get install make vim python-dev python-pip
runas pip install paramiko PyYAML Jinja2 httplib2 six
runas make install
