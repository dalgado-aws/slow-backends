#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ../common.sh
nginx_route_host=$(oc get routes ${app}-nginx-route -o jsonpath={.spec.host})

nginx_check_route="http://${nginx_route_host}/flask/check"
echo "nginx_check_route: $nginx_check_route"
curl -o /dev/null -s -w "%{http_code}" $nginx_check_route
echo ""

for waittime in 6 1 2; do
	nginx_wait_route="http://${nginx_route_host}/flask/wait/$waittime"
	echo "nginx_wait_route: $nginx_wait_route"
	time curl -o /dev/null -s -w "%{http_code}" $nginx_wait_route
	echo ""
done

