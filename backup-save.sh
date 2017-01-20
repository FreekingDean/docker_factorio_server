#!/bin/sh

SAVES=/opt/factorio/saves/*
for f in $SAVES
do
  filename=$(basename $f)
  moddate=$(stat -c %y $f)
  aws s3 cp "$f" s3://$S3_PATH
done
