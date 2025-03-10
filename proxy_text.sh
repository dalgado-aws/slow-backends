#!/usr/bin/bash

wait_minutes=6
set -x

echo "no proxy"
curl -o /dev/null -s -w "%{http_code}"  http://tiger-flask-route-dalgado-aws-dev.apps.rm2.thpm.p1.openshiftapps.com/wait/${wait_minutes}

echo "apache proxy"
curl -o /dev/null -s -w "%{http_code}"  http://tiger-apache-route-dalgado-aws-dev.apps.rm2.thpm.p1.openshiftapps.com/flask/wait/${wait_minutes}

echo "njinx proxy"
curl -o /dev/null -s -w "%{http_code}" http://tiger-njinx-route-dalgado-aws-dev.apps.rm2.thpm.p1.openshiftapps.com/wait/${wait_minutes}
