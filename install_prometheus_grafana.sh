#!/bin/bash

# Install Prometheus
sudo useradd --no-create-home --shell /bin/false prometheus
sudo mkdir /etc/prometheus /var/lib/prometheus

cd /opt
wget https://github.com/prometheus/prometheus/releases/download/v2.52.0/prometheus-2.52.0.linux-amd64.tar.gz
tar -xvf prometheus-2.52.0.linux-amd64.tar.gz
sudo cp prometheus-2.52.0.linux-amd64/{prometheus,promtool} /usr/local/bin/
sudo cp -r prometheus-2.52.0.linux-amd64/{consoles,console_libraries} /etc/prometheus/
sudo cp prometheus-2.52.0.linux-amd64/prometheus.yml /etc/prometheus/

# Prometheus Service
cat <<EOF | sudo tee /etc/systemd/system/prometheus.service
[Unit]
Description=Prometheus
After=network.target

[Service]
User=prometheus
ExecStart=/usr/local/bin/prometheus --config.file=/etc/prometheus/prometheus.yml

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reexec
sudo systemctl enable --now prometheus

# Install Grafana
sudo yum install -y https://dl.grafana.com/oss/release/grafana-10.2.3-1.x86_64.rpm
sudo systemctl enable --now grafana-server
