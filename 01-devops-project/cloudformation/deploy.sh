#!/usr/bin/env bash

aws cloudformation deploy \
  --template-file template.yaml \
  --capabilities CAPABILITY_NAMED_IAM \
  --no-fail-on-empty-changeset \
  --stack-name devops-static-site-dev