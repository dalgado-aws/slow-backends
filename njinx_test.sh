#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ./common.sh
njinx_route_host=$(oc get routes ${app}-njinx-route -o jsonpath={.spec.host})


set +x
njinx_check_route="http://${njinx_route_host}/check"
echo "njinx_check_route: $njinx_check_route"
curl -o /dev/null -s -w "%{http_code}" $njinx_check_route 
echo ""

for waittime in 6 1 2; do
	echo "..........$waittime"
	njinx_wait_route="http://${njinx_route_host}/wait/$waittime"
	echo "njinx_wait_route: $njinx_wait_route"
	date
	time curl -o /dev/null -s -w "%{http_code}" $njinx_wait_route 
	echo ""
	date
done

