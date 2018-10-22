#!/bin/bash

echo "Testing Graphite";

echo "foo.bar 321 `date +%s`" | nc localhost 2003 && echo "Metric foo.bar with value 321 sent to graphite port 2003 on `date`"

curl "http://localhost:8888/render?format=json&target=foo.bar&from=-3minutes"

echo "foo.baz 333 `date +%s`" | nc localhost 2018 && echo "Metric foo.baz with value 333 sent to graphite port 2018 on `date`"

curl "http://localhost:8888/render?format=json&target=foo.baz&from=-3minutes"

exit 0;
