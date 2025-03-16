#!/usr/bin/bash
set -e
#set -x

cd $(dirname $0) && source ../common.sh

oc delete pod tiger-nginx >/dev/null 2>&1  || echo "could not delete pod!"
flask_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
echo "flask host is :$flask_host"

oc process -f nginx_template.yaml -p APP=$app -p FLASK_HOST=$flask_host | oc apply -f -
nginx_route_host=$(oc get routes ${app}-nginx-route -o jsonpath={.spec.host})

echo "sleeping for 10s"
sleep 10s

oc logs tiger-nginx

nginx_check_route="http://${nginx_route_host}/flask/check"
echo "nginx_check_route: $nginx_check_route"
curl -o /dev/null -s -w "%{http_code}" $nginx_check_route
echo ""

