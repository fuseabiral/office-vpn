#!/bin/bash

# Step 1: Prompt for credentials and save to .vpn_credentials
echo "Creating .vpn_credentials file..."
read -p "Enter VPN username: " vpn_user
read -s -p "Enter VPN password: " vpn_pass
echo
read -s -p "Enter your sudo password: " sudo_pass
echo

cat > .vpn_credentials <<EOF
USERNAME=$vpn_user
PASSWORD=$vpn_pass
SUDO_PASSWORD=$sudo_pass
EOF

# Step 2: Install expect
echo "Installing 'expect' package..."
echo "$sudo_pass" | sudo -S apt update && echo "$sudo_pass" | sudo -S apt install -y expect

# Step 3: Secure .vpn_credentials
chmod 600 .vpn_credentials
echo ".vpn_credentials file secured."

# Step 4: Create openvpn-login.exp script
cat > openvpn-login.exp <<'EOF'
#!/usr/bin/expect -f

# Read credentials from file
set fp [open "./.vpn_credentials" r]
set lines [split [read $fp] "\n"]
close $fp

# Parse credentials
foreach line $lines {
    if {[string match "USERNAME=*" $line]} {
        set username [string range $line 9 end]
    } elseif {[string match "PASSWORD=*" $line]} {
        set password [string range $line 9 end]
    } elseif {[string match "SUDO_PASSWORD=*" $line]} {
        set sudo_password [string range $line 14 end]
    }
}

# Prompt for OTP
send_user "Enter OTP: "
expect_user -re "(.*)\n"
set otp $expect_out(1,string)
set full_password "$password$otp"

# Start OpenVPN with sudo
spawn sudo -S openvpn --config sslvpn-ssl.abiral.neupane-client-config.ovpn
expect {
    "password for" {
        send "$sudo_password\r"
        exp_continue
    }
    "Enter Auth Username:" {
        send "$username\r"
    }
}
expect "Enter Auth Password:" {
    send "$full_password\r"
}

interact
EOF

# Step 5: Make the expect script executable
chmod +x openvpn-login.exp
echo "openvpn-login.exp script created and made executable."

echo "✅ Setup complete. Run './openvpn-login.exp' to start VPN."
