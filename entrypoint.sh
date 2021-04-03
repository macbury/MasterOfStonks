#!/bin/sh

cd /mos
bin/rails db:create db:migrate db:seed

exec bin/foreman start