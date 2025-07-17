# Office VPN Setup

This guide will help you set up and connect to the Office VPN using a script-based approach.

## Prerequisites
-   Ensure you have **OpenVPN** installed on your system.
-   Download your VPN configuration file from **Sophos**. It should look like:
`sslvpn-<your-username>-client-config.ovpn`
Place this file in the **same directory** as the setup script.

## Installation & Setup
1. Make the setup script executable:
  `chmod +x ./setup-vpn.sh`
2. Run the setup script:
`./setup-vpn.sh`
Follow the on-screen instructions. This will prepare the necessary configuration and files for your VPN connection.

## Connecting to the VPN

Once setup is complete, you can connect using the following command:
    `./openvpn-login.exp`
This will prompt you for your **OTP (One-Time Password)**. Enter it when asked, and you’ll be connected to the Office VPN.
