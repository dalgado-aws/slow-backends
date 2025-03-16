#!/usr/bin/bash
set -e
#set -x

cd $(dirname $0) && source ../common.sh

oc delete pod tiger-apache >/dev/null 2>&1  || echo "could not delete pod!"
flask_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
echo "flask host is :$flask_host"

oc process -f apache_template.yaml -p APP=$app -p FLASK_HOST=$flask_host | oc apply -f -
apache_route_host=$(oc get routes ${app}-apache-route -o jsonpath={.spec.host})

echo "sleeping for 10s"
sleep 10s

oc logs tiger-apache

apache_check_route="http://${apache_route_host}/flask/check"
echo "apache_check_route: $apache_check_route"
curl -o /dev/null -s -w "%{http_code}" $apache_check_route 
echo ""


