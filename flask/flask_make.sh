#!/usr/bin/bash
set -e
set -x

cd $(dirname $0) && source ../common.sh

oc process -f flask_template.yaml -p APP=$app | oc apply -f -
echo "sleeping for 30s ....waiting for flask pod to come up"
sleep 30s

flask_route_host=$(oc get routes ${app}-flask-route -o jsonpath={.spec.host})
flask_check="http://${flask_route_host}/check"
flask_wait="http://${flask_route_host}/wait/1"

if curl -o /dev/null -s -w "%{http_code}" $flask_check | grep -q "200"; then
  echo "success: $flask_check"
  if curl -o /dev/null -s -w "%{http_code}" $flask_wait | grep -q "200"; then
    echo "success:$flask_wait"
  else
    echo "failed:$flask_wait"
  fi
else 
  echo "failed: $flask_check"
fi
