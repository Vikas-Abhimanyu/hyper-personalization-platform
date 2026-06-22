# --- Download Jenkins Agent ---
mkdir -p /opt/jenkins

cd /opt/jenkins

curl -O ${jenkins_master_url}/jnlpJars/agent.jar

# --- Create Jenkins Service User ---
useradd -m -s /bin/bash jenkins || true

mkdir -p /home/jenkins/agent

chown -R jenkins:jenkins /home/jenkins
chown -R jenkins:jenkins /opt/jenkins

cat <<EOF >/etc/systemd/system/jenkins-agent.service
[Unit]
Description=Jenkins Inbound Agent
After=network.target

[Service]
User=jenkins
WorkingDirectory=/home/jenkins/agent

ExecStart=/usr/bin/java \
  -jar /opt/jenkins/agent.jar \
  -url ${jenkins_master_url} \
  -secret ${agent_secret} \
  -name ${agent_name} \
  -workDir /home/jenkins/agent

Restart=always

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable jenkins-agent
systemctl start jenkins-agent