#!/usr/bin/env bash

DIRECTORIES=( \
"{{ cookiecutter.region }}/network/vpc" \
"{{ cookiecutter.region }}/prep/keys" \
"{{ cookiecutter.region }}/prep/iam" \
"{{ cookiecutter.region }}/prep/sg" \
"{{ cookiecutter.region }}/prep/packer" \
"{{ cookiecutter.region }}/prep/user-data" \
"{{ cookiecutter.region }}/prep/ec2" \
"{{ cookiecutter.region }}/eip/eip-main" \
)