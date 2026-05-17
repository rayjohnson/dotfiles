#!/usr/bin/env bash
# Triggers install for a specific HA update entity.
# Usage: ha-install-update.sh <entity_id>
# Example: ha-install-update.sh update.home_assistant_core_update
set -euo pipefail

entity_id="${1:?Usage: ha-install-update.sh <entity_id>}"

HA_URL=$(jq -r '.mcpServers["home-assistant"].env.HOMEASSISTANT_URL' ~/.claude/.mcp.json)
HA_TOKEN=$(jq -r '.mcpServers["home-assistant"].env.HOMEASSISTANT_TOKEN' ~/.claude/.mcp.json)

# Check if update is already in progress
in_progress=$(curl -s \
  -H "Authorization: Bearer $HA_TOKEN" \
  "$HA_URL/api/states/$entity_id" \
  | jq -r '.attributes.in_progress // false')

if [[ "$in_progress" != "false" ]]; then
  echo "Update already in progress ($in_progress) — skipping."
  exit 0
fi

echo "Triggering update install for: $entity_id"
result=$(curl -s -o /dev/null -w "%{http_code}" \
  -X POST \
  -H "Authorization: Bearer $HA_TOKEN" \
  -H "Content-Type: application/json" \
  -d "{\"entity_id\": \"$entity_id\"}" \
  "$HA_URL/api/services/update/install")

if [[ "$result" == "200" ]]; then
  echo "Update triggered. HA will apply the update and restart in the background."
else
  echo "Unexpected HTTP status: $result" >&2
  exit 1
fi
