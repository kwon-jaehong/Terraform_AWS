#!/bin/bash

for i in $(seq 1 100); do curl -s -o /dev/null "http://a81c98a7895ab4631a908c8d40fa33ec-890784739.us-east-2.elb.amazonaws.com:9080/"; done