#!/bin/sh

mv assets/node_modules assets/tmp_node_modules
heroku container:push web
heroku container:release web

mv assets/tmp_node_modules assets/node_modules
