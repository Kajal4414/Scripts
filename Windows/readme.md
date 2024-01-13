# Removing Windows Recovery Partition:

1. Open Command Prompt as Administrator:
    - Press `Win + X`, then select "Command Prompt (Admin)" or "Windows PowerShell (Admin)."
2. Launch Diskpart:
    ```sh
    diskpart
    ```
3. Identify Disk and Partitions:
    ```sh
    list disk
    select disk 0    # Replace '0' with the correct disk number where the recovery partition exists
    ```
4. Select the Recovery Partition:
    ```sh
    list partition
    select partition X    # Replace 'X' with the number of the recovery partition
    ```
5. Delete the Partition:
    ```sh
    delete partition override
    ```

# Removing Linux from GRUB Boot Menu (Assuming dual boot):

1. Open Command Prompt as Administrator:
    - Press `Win + X`, then select "Command Prompt (Admin)" or "Windows PowerShell (Admin)."
2. Identify System Partition and Assign Letter:
    ```sh
    diskpart
    list disk
    select disk 0    # Replace '0' with the correct disk number where the system partition exists
    list partition
    select partition 0    # Replace '0' with the number of the system partition
    assign letter=R
    exit
    ```
3. Access the EFI Directory and Remove Linux Entry:
    ```sh
    R:
    cd EFI
    dir    # Look for the directory containing the Linux boot files
    rd ubuntu /s    # Replace 'ubuntu' with the Linux directory name
    ```
4. Confirm Deletion:
    - Type `Y` and press Enter to confirm the deletion.
5. Reboot Your System:
    - Ensure that you restart your system to apply the changes.
  
# [Fix Windows UEFI Partition](https://youtu.be/CZ17JrgFFhw)
1. Open Command Prompt as administrator.
2. Backup and Restoring BCD (boot configuration data).
    ```sh
    bcdedit /export "C:\BCD_Backup.bcd"    # Backup
    bcdedit /import "C:\BCD_Backup.bcd"    # Restore
    ```
4. Identify the drive letter of your UEFI partition.
    ```sh
    diskpart
    list disk
    select disk 0    # Replace '0' with the disk number that contains the UEFI partition
    list partition 'OR' list volume    # Look for the 100 MB FAT32 partition
    select partition 1    # Replace '1' with the number of the EFI partition
    format fs=fat32 quick    # Format the UEFI FAT32 partition
    assign letter=V    # Assign 'V' temporary drive letter
    exit
    ```
5. Format the UEFI partition
    ```cmd
    format V: /FS:FAT32
    ```
6. [Recreate the UEFI partition](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/bcdboot-command-line-options-techref-di?view=windows-11) (Replace 'C:' with your Windows drive letter).
    ```sh
    bcdboot C:\Windows /s V: /f UEFI
    ```
7. Remove the temporary drive letter.
    ```cmd
    diskpart
    select volume V
    remove letter=V
    exit
    ```
