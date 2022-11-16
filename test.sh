#!/usr/bin/env bash

curl -v -X POST http://127.0.0.1:3000/api/todo \
   -H 'Content-Type: application/json' \
   -d '{"Text":"I need to do something"}'
