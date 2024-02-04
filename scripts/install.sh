#!/bin/sh
docker-compose -f docker-compose-init.yml down
docker-compose -f docker-compose-init.yml build 
docker-compose -f docker-compose-init.yml up -d