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

ansible-playbook \
  -i "$INVENTORY_SCRIPT" \
  "$PLAYBOOK_PATH" \
  -e "docker_domain=$DOCKER_DOMAIN docker_stack_name=$DOCKER_STACK_NAME"
