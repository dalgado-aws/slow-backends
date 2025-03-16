#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ../common.sh
apache_route_host=$(oc get routes ${app}-apache-route -o jsonpath={.spec.host})

apache_check_route="http://${apache_route_host}/flask/check"
echo "apache_check_route: $apache_check_route"
curl -o /dev/null -s -w "%{http_code}" $apache_check_route 
echo ""

for waittime in 6 1 2; do
	apache_wait_route="http://${apache_route_host}/flask/wait/$waittime"
	echo "apache_wait_route: $apache_wait_route"
	time curl -o /dev/null -s -w "%{http_code}" $apache_wait_route
	echo ""
done

