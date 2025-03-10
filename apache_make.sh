#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ./common.sh
flask_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
echo "flask route is :$flask_route"
oc process -f apache_template.yaml -p APP=$app -p FLASK_HOST=$flask_host | oc apply -f -
apache_route_host=$(oc get routes ${app}-apache-route -o jsonpath={.spec.host})

echo "sleeping for 10s"
sleep 10s

oc logs tiger-apache

set +x
apache_check_route="http://${apache_route_host}/flask/check"
echo "apache_check_route: $apache_check_route"
curl -o /dev/null -s -w "%{http_code}" $apache_check_route 
echo ""


