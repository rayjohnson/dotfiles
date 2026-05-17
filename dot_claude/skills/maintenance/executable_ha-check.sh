#!/usr/bin/env bash
set -euo pipefail

HA_URL=$(jq -r '.mcpServers["home-assistant"].env.HOMEASSISTANT_URL' ~/.claude/.mcp.json)
HA_TOKEN=$(jq -r '.mcpServers["home-assistant"].env.HOMEASSISTANT_TOKEN' ~/.claude/.mcp.json)

STATES=$(curl -s -H "Authorization: Bearer $HA_TOKEN" "$HA_URL/api/states")

echo "=== BATTERY STATUS ==="
result=$(echo "$STATES" | jq -r '
  [.[] | select(
    (.attributes.device_class == "battery") and
    (.state | tonumber? // -1) >= 0 and
    (.entity_id | test("charger_|solar_|watch_battery|_internal_battery|iphone_[0-9]+_battery|allies_macbook|rays_12pro_battery|rays_iphone_battery_level|cynthias_iphone_battery_level|bob_charge_limit|backup_reserve") | not)
  ) |
  (.state | tonumber) as $pct |
  (if $pct < 20 then "⚠️ " else "🟢" end) as $icon |
  "  \($icon)  \($pct)%  \(.attributes.friendly_name // .entity_id)"]
  | sort | .[]')
if [[ -z "$result" ]]; then
  echo "  (none)"
else
  echo "$result"
fi

echo ""
echo "=== UNAVAILABLE INFRASTRUCTURE ==="
# Filtered out: mobile companion-app sensors, old stale iPhone entities,
# robot vacuum (bob), UniFi port power-cycle buttons, and known noisy sensors
result=$(echo "$STATES" | jq -r '
  [.[] | select(
    .state == "unavailable" and
    (.entity_id | test("^(sensor|binary_sensor|switch|light|lock|cover|climate|camera|alarm)")) and
    (.entity_id | test("power_cycle|us_24|udm|hallway|dining_room|restart|identify|ipad_|cynthias_iphone_|thunes_|rays_12pro_|allies_macbook|iphone_[0-9]+_battery|bob_|skinet") | not)
  ) | "  \(.entity_id)  (\(.attributes.friendly_name // "unnamed"))"]
  | sort | .[]')
if [[ -z "$result" ]]; then
  echo "  (none)"
else
  echo "$result"
fi

echo ""
echo "=== FIRMWARE UPDATES AVAILABLE ==="
result=$(echo "$STATES" | jq -r '
  [.[] | select(
    (.entity_id | startswith("update.")) and (.state == "on")
  ) | "  PENDING  \(.entity_id)  \(.attributes.friendly_name): \(.attributes.installed_version) → \(.attributes.latest_version)"]
  | .[]')
if [[ -z "$result" ]]; then
  echo "  (none)"
else
  echo "$result"
fi

echo ""
echo "=== FIRMWARE CHECK UNAVAILABLE ==="
result=$(echo "$STATES" | jq -r '
  [.[] | select(
    (.entity_id | startswith("update.")) and (.state == "unavailable")
  ) | "  \(.attributes.friendly_name // .entity_id)"]
  | .[]')
if [[ -z "$result" ]]; then
  echo "  (none)"
else
  echo "$result"
fi
