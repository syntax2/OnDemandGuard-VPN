<#
.SYNOPSIS
  Initializes a VPN project scaffold with folders and SEO-optimized README.

.DESCRIPTION
  Creates the directory structure and placeholder files for your personal VPN project.
  Includes inline comments so you can learn PowerShell basics as you go.

.PARAMETER ProjectName
  Name of the root project folder to create.

.EXAMPLE
  .\init-vpn-project.ps1 -ProjectName "my-vpn-project"
#>

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# 1. Define the folders we want
$folders = @(
    "",            # the root
    "src",         # source code (e.g. setup scripts)
    "config",      # VPN config templates
    "scripts",     # helper/deployment scripts
    "docs",        # design docs, architecture
    "tests",       # test cases, validation scripts
    "logs"         # runtime logs
)

Write-Host "Creating project structure for '$ProjectName'..."

# 2. Loop to create each folder
foreach ($f in $folders) {
    $path = Join-Path -Path $ProjectName -ChildPath $f
    if (-not (Test-Path $path)) {
        New-Item -Path $path -ItemType Directory | Out-Null
        Write-Host "  Created folder: $path"
    } else {
        Write-Host "  Exists: $path"
    }
}

# 3. Create description.txt with an SEO-optimized blurb
$description = @"
Personal VPN Server on AWS Free Tier – Secure your internet traffic, bypass geo-restrictions, and retain full control over your data. 
This project walks you through setting up a high-performance VPN (WireGuard or OpenVPN) on a Linux EC2 instance, covering:
- End-to-end encryption (AES-256, Curve25519)
- Automated key management
- Firewall (iptables/nftables) and NAT configuration
- Scalability with Terraform/Ansible
"@

$descPath = Join-Path $ProjectName "description.txt"
$description | Out-File -Encoding UTF8 -FilePath $descPath
Write-Host "  Created: description.txt"

# 4. Build an SEO-optimized README.md
$readme = @"
# $ProjectName

**Personal VPN Server on AWS Free Tier** – Learn to build and deploy your own secure VPN using modern protocols and best practices.

## 🚀 Project Overview
- **Protocols Supported:** WireGuard, OpenVPN, IPsec (StrongSwan)
- **Platform:** Ubuntu 22.04 LTS on AWS EC2 (t2.micro)
- **Security:** AES-256, Curve25519, IKEv2, HMAC
- **Automation:** Ansible playbooks, Terraform scripts

## 📂 Directory Structure

"@