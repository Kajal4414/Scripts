# To Backup the UEFI Partition (BCD Store):

1. **Open Command Prompt as Administrator:**
   - Press `Win + X` and select "Windows PowerShell (Admin)" or "Command Prompt (Admin)" from the menu.

2. **Create a Backup Directory:**
   - Choose a location where you want to save the BCD backup. For example, you can create a folder in your C: drive named "BCD_Backup".

3. **Use the `bcdedit` Command:**
   - In the Command Prompt, type the following command to export the BCD store to a file in your backup directory:
     ```
     bcdedit /export C:\BCD_Backup\bcdbackup
     ```
   - Replace `C:\BCD_Backup\bcdbackup` with your chosen path and filename.

4. **Verify the Backup:**
   - Navigate to the backup directory to ensure that the file `bcdbackup` has been created.

5. **Keep the Backup Safe:**
   - It's a good idea to copy this backup to an external drive or cloud storage for safekeeping.

## To Restore the UEFI Partition (BCD Store):

1. **Open Command Prompt as Administrator:**
   - As before, open an elevated Command Prompt.

2. **Use the `bcdedit` Command:**
   - Type the following command to restore the BCD store from the backup file:
     ```
     bcdedit /import C:\BCD_Backup\bcdbackup
     ```
   - Replace `C:\BCD_Backup\bcdbackup` with the path to your backup file.

Please note that restoring the BCD store is a sensitive operation and should be done with caution. Make sure to use the correct path to your backup file and understand that this process will overwrite the current BCD configuration.

---

# How to Format the UEFI Partition and Recreate the UEFI Partition

## To Format the UEFI Partition:

1. **Boot from Windows Installation Media:**
   - Insert your Windows installation USB or DVD and boot from it.

2. **Open a Command Prompt:**
   - On the initial Windows Setup screen, press `Shift + F10` to open a Command Prompt.

3. **Identify the UEFI Partition:**
   - Use the `diskpart` utility to identify the EFI System Partition (ESP):
     ```
     diskpart
     list disk
     select disk # (replace # with the number of the disk that contains the EFI partition)
     list partition
     select partition # (replace # with the number of the EFI partition)
     ```
   - The EFI partition is usually formatted as FAT32 and has a size between 100MB and 1GB.

4. **Format the UEFI Partition:**
   - Once you have selected the EFI partition, you can format it:
     ```
     format fs=fat32
     ```
   - Wait for the process to complete.

## To Recreate the UEFI Partition:

1. **Delete the Old UEFI Partition:**
   - Use the `diskpart` utility to delete the old UEFI partition:
     ```
     select partition # (replace # with the number of the EFI partition)
     delete partition
     ```

2. **Create a New UEFI Partition:**
   - You'll need to create a new partition and format it as FAT32:
     ```
     create partition efi size=260
     format quick fs=fat32 label="System"
     assign letter=S
     ```
   - The size of 260MB is generally recommended for the EFI partition.

3. **Recreate the BCD Store:**
   - After creating and formatting the new EFI partition, you'll need to recreate the Boot Configuration Data (BCD):
     ```
     bcdboot C:\windows /s S: /f UEFI
     ```
   - Replace `C:\windows` with the path to your Windows directory if it's different.

4. **Exit and Reboot:**
   - Type `exit` to close the Command Prompt and then reboot your computer.

Please note that these steps can vary based on your specific system configuration and the version of Windows you are using. If you are not comfortable with these steps or if you encounter any issues, it may be best to seek assistance from a professional or use the built-in Windows recovery options.
