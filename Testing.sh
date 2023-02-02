#!/bin/bash
#
# (c) Alphons van der Heijden
#

if [ "$(id -u)" -eq 0 ]; then echo "Please run as user (not root)." >&2; exit 1; fi

read -p "Clean Sytem [1] Install all again [2] " onetwo

if [[ $onetwo == "1" ]]; then
  array=(/tmp/tcloop/*)
  for dir in "${array[@]}"; do 
    sudo umount -v -l $dir  
  done

  TCE=/etc/sysconfig/tcedir
  sudo rm -rf $TCE/ondemand/*
  sudo rm -rf $TCE/optional/*
  sudo rm -rf /usr/local/tce.installed/*
  echo "" > $TCE/onboot.lst

  filetool.sh -b

  read -p "Reboot [Yn] ? " yesno
  if [[ $yesno == "Y" ]]; then
    sudo reboot
  else
    echo "sudo reboot as soon as possible"
    exit 0
  fi
fi

if [[ $onetwo == "2" ]]; then

echo "Installing packages" 

tce-load -wi bash joe libtirpc samba openssh ca-certificates rsync mkisofs-tools
tce-load -wi coreutils compiletc gcc binutils make squashfs-tools ncursesw-dev bison 
tce-load -wi flex-dev openssl-1.1.1-dev elfutils-dev gettext-dev bc perl5 python3.9 texinfo
tce-load -wi curl dotnet7-sdk mongo

echo "Packages are installed"

echo "Making the system having passwords for tc and root"
echo "For publishing on github, this part is skipped"
#sudo cp passwd /etc
#sudo cp shadow /etc

echo "Setting ntp (time) for the Netherlands etc/ntp.conf"

sudo mkdir -p /etc/ntp
sudo tee /etc/ntp.conf >/dev/null << "EOF"
# --- GENERAL CONFIGURATION ---
server 0.nl.pool.ntp.org
server 1.nl.pool.ntp.org
server 2.nl.pool.ntp.org
server 3.nl.pool.ntp.org
# Drift file.
driftfile /etc/ntp/drift
EOF

echo "Creating some basic samba config (everyone is root!)"
  
sudo mkdir -p /usr/local/etc/samba
sudo tee /usr/local/etc/samba/smb.conf >/dev/null << "EOF"
[global]
   load printers = no
   guest account = root
   workgroup = WORKGROUP

   netbios name = tinycore11
   dns proxy = no
   max log size = 1000

   server role = standalone server
   map to guest = bad user
   usershare allow guests = yes

[Root]
   comment = All
   path = /
   read only = no
   public = yes
   guest ok = yes
EOF

echo "Creating some basic ssh config"

sudo cp /usr/local/etc/ssh/ssh_config.orig /usr/local/etc/ssh/ssh_config
sudo cp /usr/local/etc/ssh/sshd_config.orig /usr/local/etc/ssh/sshd_config

echo "Creating entries in bootlocal.sh for ntpd, samba and ssh"

echo "#!/bin/sh" | sudo tee /opt/bootlocal.sh >/dev/null
echo "/usr/local/etc/init.d/openssh start" | sudo tee -a /opt/bootlocal.sh >/dev/null
echo "/usr/local/etc/init.d/samba start" | sudo tee -a /opt/bootlocal.sh >/dev/null
echo "export TZ=CET" | sudo tee -a /opt/bootlocal.sh >/dev/null
echo "/usr/sbin/ntpd" | sudo tee -a /opt/bootlocal.sh >/dev/null

echo "Executing opt/bootlocal.sh"

sudo /opt/bootlocal.sh

echo "ntpd, ssh and samba are started"

echo "Make .ashrc for user tc"

cat > /home/tc/.ashrc << "EOF"
# ~/.ashrc: Executed by Shells.
#
. /etc/init.d/tc-functions
if [ -n "$DISPLAY" ]
then
	`which editor >/dev/null` && EDITOR=editor || EDITOR=joe
else
	EDITOR=joe
fi
export EDITOR

# Alias definitions.
#
alias df='df -h'
alias du='du -h'

alias ls='ls --color=auto -p'
alias ll='ls -l'
alias la='ls -la'

# Avoid errors... use -f to skip confirmation.
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

alias ce='cd /etc/sysconfig/tcedir'
EOF


echo "making .joerc for tc and root"

cp /usr/local/etc/joe/joerc /home/tc/.joerc
sudo cp /usr/local/etc/joe/joerc /root/.joerc

echo "Patching .joerc for nobackups"

sed -i 's/.*-nobackups/-nobackups/' /home/tc/.joerc
sed -i 's/.*-nobackups/-nobackups/' /root/.joerc

echo "Copy .filetool.lst for backup those files"

cat > /opt/filetool.lst << "EOF"
opt
home
root
etc/passwd
etc/shadow
etc/ntp
etc/ntp.conf
usr/local/etc/ssh
usr/local/etc/samba
EOF

echo "Running filetool.sh -b"

filetool.sh -b

echo "--"

echo "Ready"

fi
