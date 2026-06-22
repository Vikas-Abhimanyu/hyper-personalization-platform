#!/bin/bash
set -euxo pipefail

# --- Update System ---
dnf update -y

# --- Install Utilities ---
dnf install -y \
    git \
    curl \
    wget \
    unzip \
    tar

# --- Install Java 21 ---
dnf install -y java-21-amazon-corretto

# --- Add Jenkins Repository ---
curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key \
    | tee /etc/pki/rpm-gpg/jenkins.io.key

cat <<EOF >/etc/yum.repos.d/jenkins.repo
[jenkins]
name=Jenkins
baseurl=https://pkg.jenkins.io/redhat-stable
gpgcheck=1
gpgkey=file:///etc/pki/rpm-gpg/jenkins.io.key
EOF

# --- Install Jenkins LTS ---
dnf install -y jenkins

# --- Enable Jenkins ---
systemctl daemon-reload
systemctl enable jenkins
systemctl start jenkins

# --- Configure Firewall (optional if SG handles traffic) ---
systemctl disable firewalld || true
systemctl stop firewalld || true

# --- Verify ---
java -version
systemctl status jenkins  