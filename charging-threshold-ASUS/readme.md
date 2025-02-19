## Shell Command
```
sudo mv battery.sh /usr/local/bin/battery
```

```
sudo chmod +x /usr/local/bin/battery
```
## Systemd
```
nano /etc/systemd/system/battery.service
```
```bash
[Unit]
Description=Run battery command on boot

[Service]
ExecStart=/usr/local/bin/battery --80
User=root
Group=root
#Restart=always

[Install]
WantedBy=multi-user.target
```