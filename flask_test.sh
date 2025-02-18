#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ./common.sh
flask_route_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
flask_route="http://${flask_route_host}/wait/1"
echo "flask route is :$flask_route"
curl $flask_route
