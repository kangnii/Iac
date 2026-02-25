#!/usr/bin/env bash
set -euo pipefail

# Dynamic inventory backed by OpenTofu output.
# Expected output name: instance_ip

SSH_USER="${SSH_USER:-ubuntu}"
SSH_KEY_PATH="${SSH_KEY_PATH:-$HOME/.ssh/id_rsa}"
TF_DIR="${TF_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"

get_ip() {
  local json
  json="$(tofu -chdir="$TF_DIR" output -json 2>/dev/null || echo '{}')"
  jq -r '.instance_ip.value // empty' <<<"$json"
}

print_inventory() {
  local ip
  ip="$(get_ip)"

  if [[ -z "$ip" ]]; then
    cat <<'JSON'
{
  "_meta": { "hostvars": {} },
  "all": { "hosts": [] }
}
JSON
    return 0
  fi

  cat <<JSON
{
  "_meta": {
    "hostvars": {
      "$ip": {
        "ansible_host": "$ip",
        "ansible_user": "$SSH_USER",
        "ansible_ssh_private_key_file": "$SSH_KEY_PATH"
      }
    }
  },
  "all": { "hosts": ["$ip"] }
}
JSON
}

case "${1:-}" in
  --list)
    print_inventory
    ;;
  --host)
    # Host-specific vars are already provided under _meta.hostvars.
    echo "{}"
    ;;
  *)
    echo "Usage: $0 --list | --host <hostname>" >&2
    exit 1
    ;;
esac
