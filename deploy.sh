#!/bin/sh

mv assets/node_modules assets/tmp_node_modules
sleep 5
heroku container:push web
sleep 5
heroku container:release web

mv assets/tmp_node_modules assets/node_modules
