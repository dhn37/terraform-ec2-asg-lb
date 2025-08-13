#!/bin/bash
yum update -y
yum install -y nc

# Run a simple TCP echo server on port 443
cat << 'EOF' > /opt/tcp-server.sh
#!/bin/bash
while true; do
  echo -e "Hello from NLB TCP test" | nc -l -p 443
done
EOF

chmod +x /opt/tcp-server.sh

# Start it as a service
nohup /opt/tcp-server.sh &
