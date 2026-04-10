#!/bin/bash
# Installs a Safari AutoFill configuration profile that disables password and credit card
# autofill (use 1Password instead). Requires one manual approval click in System Settings.
#
# After running, go to System Settings > General > Device Management and click "Install".

PROFILE_PATH="$HOME/.config/safari-autofill.mobileconfig"

PAYLOAD_UUID=$(uuidgen)
PROFILE_UUID=$(uuidgen)

cat > "$PROFILE_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PayloadContent</key>
    <array>
        <dict>
            <key>AutoFillPasswords</key>
            <false/>
            <key>AutoFillCreditCardData</key>
            <false/>
            <key>PayloadDescription</key>
            <string>Disables Safari AutoFill for passwords and credit cards</string>
            <key>PayloadDisplayName</key>
            <string>Safari AutoFill Settings</string>
            <key>PayloadIdentifier</key>
            <string>com.ray.safari-autofill</string>
            <key>PayloadType</key>
            <string>com.apple.Safari</string>
            <key>PayloadUUID</key>
            <string>${PAYLOAD_UUID}</string>
            <key>PayloadVersion</key>
            <integer>1</integer>
        </dict>
    </array>
    <key>PayloadDescription</key>
    <string>Disables Safari AutoFill for passwords and credit cards</string>
    <key>PayloadDisplayName</key>
    <string>Safari AutoFill</string>
    <key>PayloadIdentifier</key>
    <string>com.ray.safari-autofill-profile</string>
    <key>PayloadRemovalDisallowed</key>
    <false/>
    <key>PayloadType</key>
    <string>Configuration</string>
    <key>PayloadUUID</key>
    <string>${PROFILE_UUID}</string>
    <key>PayloadVersion</key>
    <integer>1</integer>
</dict>
</plist>
EOF

echo "Opening Safari AutoFill profile installer..."
echo "When System Settings opens, click 'Install' under General > Device Management."
open "$PROFILE_PATH"
