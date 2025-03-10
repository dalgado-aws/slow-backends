#!/usr/bin/bash
#
cd $(dirname $0) && source ./common.sh
oc delete pods -l pod-selector=njinx
