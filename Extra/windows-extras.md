https://www.lifewire.com/delete-windows-recovery-partition-4128723
Remove windows recovery partition

$ run "cmd" as admin and type "diskpart"

$ list disk
$ select disk 0
$ list partition
$ select partition 4 (recovery partetion)
$ delete partition override
________________________________________________________________
Remove linux from grub boot menu

$ run "cmd" as admin and type "diskpart"
$ list disk
$ select disk 0
$ list partition
$ select partition 1 (system partetion)
$ assign letter=r
$ exit

$ r:
$ dir
$ cd EFI
$ dir
$ rd ubuntu /s 
Type 'Y' to delete

Reboot the system
