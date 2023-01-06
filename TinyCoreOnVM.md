## As an example building a (64bit) VM for Tinycore

Download (latest) CorePure64 iso from www.tinycorelinux.net

http://tinycorelinux.net/13.x/x86_64/release/CorePure64-13.1.iso]http://tinycorelinux.net/13.x/x86_64/release/CorePure64-13.1.iso

Download (latest) VMWare player from www.vmware.com

https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html]https://www.vmware.com/products/workstation-player/workstation-player-evaluation.html

My download link on 2023-01-06 was:

https://download3.vmware.com/software/WKST-PLAYER-1700/VMware-player-full-17.0.0-20800274.exe]https://download3.vmware.com/software/WKST-PLAYER-1700/VMware-player-full-17.0.0-20800274.exe

- Install VMWare player
- Start VMWare player
- Create New Virtual Machine
  - radio: Install dics image file (iso): pointing to CorePure64-13.1.iso
  - Next
  - radio: Linux
  - Name: TinyCore
  - Next
  - Maximum disk size (GB): 8 GB
  - radio: Store virtual disk as a single file
  - Next
  - Finish

### Small changes to the .vmx file before starting vm
Edit de .vmx file to change scsi0 and ehternet0 to vmware stuff
scsi0.virtualDev = "pvscsi"
ethernet0.virtualDev = "vmxnet3"
  
  - Play Virtual Machine
 
### first boot

Core has autologin for user tc, where tc is a sudoer

```
  - on prompt boot: <enter>

  tc@box:~$ sudo fdisk /dev/sda

- type: n <enter> p <enter> 1 <enter> <enter> <enter> w <enter>

  tc@box:~$ sudo mkfs.ext4 /dev/sda1
  tc@box:~$ sudo reboot
```

### second boot
 
```
- on prompt boot: corepure64 tce=sda1 <enter>

- Lets install some extensions

  tc$box:~$ tce-load -wi openssh
  tc$box:~$ sudo su
  tc$box:~# cp /usr/local/etc/ssh/ssh_config.orig /usr/local/etc/ssh/ssh_config
  tc$box:~# cp /usr/local/etc/ssh/sshd_config.orig /usr/local/etc/ssh/sshd_config
  tc$box:~# echo "/usr/local/etc/init.d/openssh start" >> /opt/bootlocal.sh
  tc$box:~# /opt/bootlocal.sh

- first run of openssh does some sha initialisation

  tc$box:~# exit
  tc$box:~$ echo "etc" >> /opt/.filetool.lst
  tc$box:~$ echo "usr/local/etc" >> /opt/.filetool.lst
  tc$box:~$ passwd

- add a password for user tc, this is necessary for login using ssh
- backup these changes for restore on next reboot

  tc@box:~$ filetool.sh -b

  tc$box:~$ ifconfig (to get the IP address)
```

Example use ssh from a windows DOS prompt> ssh 192.168.x.y -l tc

UserData can be found at /mnt/sda1

### Changes are restored after every reboot
```
  tc$box:~$ sudo reboot
```

