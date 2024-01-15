# [Charging threshold for ASUS laptops](https://github.com/sakshiagrwal/Scripts/commit/19c9d7041010e2d7055682404118089d69c3e39d)

1. To move the file 'battery-charge-threshold.service' to the directory '/etc/systemd/system/', you can use the following command:

    ```sh
    sudo mv battery-threshold.service /etc/systemd/system/
    ```

2. You may also need to reload the systemd daemon after moving the file, so that it recognizes the new location of the service file. To do this, run the following command:

    ```sh
    sudo systemctl daemon-reload
    ```

3. If you want the service to start automatically at boot, you can enable it using the following command:

    ```sh
    sudo systemctl enable battery-threshold.service
    ```

4. Once the service is enabled, you can start it using:

    ```sh
    sudo systemctl start battery-threshold.service
    ```

6. Check the status of the service to ensure it's running without errors:

    ```sh
    cat /sys/class/power_supply/BAT0/charge_control_end_threshold
    ```
    
    ```sh
    sudo systemctl status battery-threshold.service
    ```

**Note:** You will need to have root privileges to move the service file and reload the systemd daemon.
