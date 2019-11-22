#!/usr/bin/env bash

DIRECTORIES=( \
"{{ cookiecutter.region }}/network/vpc" \
"{{ cookiecutter.region }}/prep/iam" \
"{{ cookiecutter.region }}/prep/sg" \
"{{ cookiecutter.region }}/prep/packer" \
"{{ cookiecutter.region }}/prep/keys" \
"{{ cookiecutter.region }}/prep/user-data" \
"{{ cookiecutter.region }}/prep/ec2" \
)