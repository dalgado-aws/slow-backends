#!/usr/bin/bash
set -e
set -x

oc delete configmap nginx-config || echo "cannot delete configmap"
oc delete pod nginx-proxy-pod || echo "cannot delete pod"

cd $(dirname $0) && source ./common.sh
flask_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
echo "flask route is :$flask_route"
oc process -f njinx_template.yaml -p APP=$app -p FLASK_HOST=$flask_host | oc apply -f -
njinx_route_host=$(oc get routes ${app}-njinx-route -o jsonpath={.spec.host})

echo "sleeping for 10s"
sleep 10s

oc logs nginx-proxy-pod

njinx_wait_route="http://${njinx_route_host}/check"
echo "njinx_wait_route: $njinx_wait_route"
curl -o /dev/null -s -w "%{http_code}" $njinx_wait_route 
echo ""

