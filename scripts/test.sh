#!/bin/bash

echo "Testing Graphite";

echo "foo.bar 321 `date +%s`" | nc localhost 2003 && echo "Metric foo.bar with value 321 sent to graphite on `date`"

curl "http://localhost:8888/render?format=json&target=foo.bar&from=-3minutes"

exit 0;
