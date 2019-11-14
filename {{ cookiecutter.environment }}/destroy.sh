#!/usr/bin/env bash
set -euo pipefail
# Cache the plugins
mkdir -p ~/.terraform.d/plugin-cache
export TF_PLUGIN_CACHE_DIR=~/.terraform.d/plugin-cache
export TF_INPUT=0

reverse() {
  tac <(echo "$@" | tr ' ' '\n') | tr '\n' ' '
}

OKRED='\033[91m'
OKGREEN='\033[92m'
OKORANGE='\033[93m'
RESET='\e[0m'

read -p 'Stack: ' stack

. ./configs/$stack.sh

SSH_KEY_FILE=/home/`whoami`/.ssh/icon_node
if [ -f "$SSH_KEY_FILE" ]; then
    echo "$SSH_KEY_FILE exists"
else
    cd ~/.ssh && ssh-keygen -t rsa -b 4096 -f icon_node -N ""
fi

export AWS_DEFAULT_REGION="{{ cookiecutter.region }}"
export AWS_ACCESS_KEY_ID="{{ cookiecutter.AWS_ACCESS_KEY_ID }}"
export AWS_SECRET_ACCESS_KEY="{{ cookiecutter.AWS_SECRET_ACCESS_KEY }}"
export TF_VAR_corporate_ip="`curl ifconfig.co`"
export TF_VAR_local_public_key=$SSH_KEY_FILE.pub
export TF_VAR_local_private_key=$SSH_KEY_FILE
export TF_VAR_config_private_key=$SSH_KEY_FILE

for i in `reverse ${DIRECTORIES[@]}`
do
    echo -e "$OKRED*****************************************************************$RESET"
	echo -e "$OKRED*$RESET$OKORANGE \t Destroying $i\t \t $RESET$OKRED$RESET"
	echo -e "$OKRED*****************************************************************$RESET"
	echo ""
    terragrunt destroy --terragrunt-non-interactive --auto-approve --terragrunt-working-dir $i
    echo $i >> ./log.txt
done

#--terragrunt-source-update