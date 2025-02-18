#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ./common.sh
flask_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
echo "flask route is :$flask_route"
oc process -f apache_template.yaml -p APP=$app -p FLASK_HOST=$flask_host | oc apply -f -
apache_route_host=$(oc get routes ${app}-apache-route -o jsonpath={.spec.host})

echo "sleeping for 30s"
sleep 30s

set +x
apache_check_route="http://${apache_route_host}/flask/check"
echo "apache_check_route: $apache_check_route"
curl -o /dev/null -s -w "%{http_code}" $apache_check_route 
echo ""

apache_wait_route="http://${apache_route_host}/flask/wait/1"
echo "apache_wait_route: $apache_wait_route"
curl -o /dev/null -s -w "%{http_code}" $apache_wait_route 
echo ""

