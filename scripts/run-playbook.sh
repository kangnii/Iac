#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
INVENTORY_SCRIPT="$ROOT_DIR/scripts/inventory.sh"
PLAYBOOK_PATH="${PLAYBOOK_PATH:-$ROOT_DIR/playbook.yaml}"

# Example Docker variables that can be consumed by Ansible templates/tasks.
DOCKER_DOMAIN="${DOCKER_DOMAIN:-docker.localhost}"
DOCKER_STACK_NAME="${DOCKER_STACK_NAME:-proxy}"

if [[ ! -x "$INVENTORY_SCRIPT" ]]; then
  chmod +x "$INVENTORY_SCRIPT"
fi

PLAN_FILE="$ROOT_DIR/.tofu.plan"

tofu -chdir="$ROOT_DIR" init -input=false
tofu -chdir="$ROOT_DIR" plan -input=false -out="$PLAN_FILE"
tofu -chdir="$ROOT_DIR" apply -input=false -auto-approve "$PLAN_FILE"
rm -f "$PLAN_FILE"

ansible-playbook \
  -i "$INVENTORY_SCRIPT" \
  "$PLAYBOOK_PATH" \
  -e "docker_domain=$DOCKER_DOMAIN docker_stack_name=$DOCKER_STACK_NAME"
