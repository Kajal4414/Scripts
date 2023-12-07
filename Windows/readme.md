# Removing Windows Recovery Partition:

1. Open Command Prompt as Administrator:
    - Press `Win + X`, then select "Command Prompt (Admin)" or "Windows PowerShell (Admin)."
2. Launch Diskpart:
    ```cmd
    diskpart
    ```
3. Identify Disk and Partitions:
    ```cmd
    list disk
    select disk 0  // Replace '0' with the correct disk number where the recovery partition exists
    ```
4. Select the Recovery Partition:
    ```cmd
    list partition
    select partition X  // Replace 'X' with the number of the recovery partition
    ```
5. Delete the Partition:
    ```cmd
    delete partition override
    ```

# Removing Linux from GRUB Boot Menu (Assuming dual boot):

1. Open Command Prompt as Administrator:
    - Press `Win + X`, then select "Command Prompt (Admin)" or "Windows PowerShell (Admin)."
2. Identify System Partition and Assign Letter:
    ```cmd
    diskpart
    list disk
    select disk 0  // Replace '0' with the correct disk number where the system partition exists
    list partition
    select partition Y  // Replace 'Y' with the number of the system partition
    assign letter=R
    exit
    ```
3. Access the EFI Directory and Remove Linux Entry:
    ```cmd
    R:
    cd EFI
    dir  // Look for the directory containing the Linux boot files
    rd ubuntu /s  // Replace 'ubuntu' with the Linux directory name
    ```
4. Confirm Deletion:
    - Type `Y` and press Enter to confirm the deletion.
5. Reboot Your System:
    - Ensure that you restart your system to apply the changes.
