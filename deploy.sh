#!/bin/sh

heroku container:push web
sleep 5
heroku container:release web

