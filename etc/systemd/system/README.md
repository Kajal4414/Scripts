### Set Charging Thresholds For ASUS Laptops On Linux [19c9d70](https://github.com/sakshiagrwal/Scripts/commit/19c9d7041010e2d7055682404118089d69c3e39d)

---

- To move the file 'battery-charge-threshold.service' to the directory '/etc/systemd/system/', you can use the following command:

```bash
sudo mv battery-charge-threshold.service /etc/systemd/system/
```

#

- You may also need to reload the systemd daemon after moving the file, so that it recognizes the new location of the service file. To do this, run the following command:

```bash
sudo systemctl daemon-reload
```

#

- Once the systemd daemon has been reloaded, you can start the service using the following command:

```bash
sudo systemctl start battery-charge-threshold.service
```

#

- If you want the service to start automatically at boot, you can enable it using the following command:

```bash
sudo systemctl enable battery-charge-threshold.service
```

---

**Note:** You will need to have root privileges to move the service file and reload the systemd daemon.
