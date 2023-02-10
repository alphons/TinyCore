# Metrics booting TinyCore 64 Kernel 6.1.2 on VMWare Player 17

Here are some details on booting TinyCore on my test system.

This [Config-6.1.2-TinyCore64-vmware](https://github.com/alphons/TinyCore/blob/main/src/Config-6.1.2-TinyCore64-vmware) file is used for compilinng kernel and modules.

Kernel is downloaded directly from [www.kernel.org](https://kernel.org) and compiled stripping all not used features because it runs on VMWare / esxi. 

Building / Toolchain of the alpha release of [TinyCore 14](http://repo.tinycorelinux.net/14.x/x86_64/release_candidates/distribution_files/) is used.

Kernel is booted without any bootloader, it makes use of the [bootsector-linux-loader](/alphons/bootsector-linux-loader) which presents the bootable disk as a .vmdk file which kan be used directly in VMWare

There are no TinyCore extensions loaded albeit the netwerk and TinyCore infrastructure works out of the box.

For practical use a data disk has to be attached and some swap space on disk will be needed.

## dmesg

The lengthy dmesg.txt is uploaded as a seperate file.

Showing here some head and tails.

[dmesg.txt](dmesg.txt)
```
[    0.000000] Linux version 6.1.2-tinycore64 (tc@box) (gcc (GCC) 12.2.0, GNU ld (GNU Binutils) 2.39) #4 SMP Fri Feb 10 08:07:52 UTC 2023
[    0.000000] Command line: loglevel=3
[    0.000000] Disabled fast string operations
....
....
....
[    2.015148] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.020279] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.035924] squashfs: version 4.0 (2009/01/31) Phillip Lougher
[    2.045480] process '/sbin/ldconfig' started with executable stack
[    2.269766] vmxnet3 0000:03:00.0 eth0: intr type 3, mode 0, 5 vectors allocated
[    2.270197] vmxnet3 0000:03:00.0 eth0: NIC Link is Up 10000 Mbps
[    2.274638] NET: Registered PF_PACKET protocol family
```

Total boot-time under 2.5 seconds.

# free

```
total        used        free      shared  buff/cache   available
Mem:         501008       45324      439240       10060       16444      436368
Swap:         67744           0       67744
```

# df

```
Filesystem                Size      Used Available Use% Mounted on
rootfs                  440.3M      9.8M    430.5M   2% /
tmpfs                   244.6M         0    244.6M   0% /dev/shm

```

# ifconfig
```
eth0      Link encap:Ethernet  HWaddr 00:0C:29:CE:B8:89  
          inet addr:192.168.28.34  Bcast:192.168.28.255  Mask:255.255.255.0
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:27849 errors:0 dropped:0 overruns:0 frame:0
          TX packets:6953 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:34992574 (33.3 MiB)  TX bytes:582996 (569.3 KiB)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)


```

# lsmod

The kernel config uses as much modules as possible. Just a few are needed to be in the kernel.

```
Module                  Size  Used by    Not tainted
af_packet              36864  0 
cpufreq_userspace      12288  0 
cpufreq_powersave      12288  0 
cpufreq_ondemand       12288  0 
cpufreq_conservative    12288  0 
squashfs               36864 32 
zstd_decompress        57344  1 squashfs
zstd_common            16384  1 zstd_decompress
lz4_decompress         20480  1 squashfs
mousedev               16384  0 
atkbd                  16384  0 
psmouse                20480  0 
vivaldi_fmap           12288  1 atkbd
evdev                  16384  0 
libps2                 12288  2 atkbd,psmouse
pcspkr                 12288  0 
sg                     28672  0 
sd_mod                 28672  0 
t10_pi                 12288  1 sd_mod
rtc_cmos               16384  1 
i8042                  20480  0 
ata_generic            12288  0 
serio                  16384  5 atkbd,psmouse,i8042
vmxnet3                45056  0 
ata_piix               20480  0 
pata_acpi              12288  0 
vmw_vmci               45056  0 
libata                122880  3 ata_generic,ata_piix,pata_acpi
loop                   20480 64 
ac                     12288  0 
unix                   32768 54 

```

# modprobe -l

All available modules in this build.

```
kernel/drivers/input/keyboard/atkbd.ko.gz
kernel/drivers/cpufreq/cpufreq_conservative.ko.gz
kernel/net/key/af_key.ko.gz
kernel/drivers/scsi/sd_mod.ko.gz
kernel/net/vmw_vsock/vmw_vsock_vmci_transport.ko.gz
kernel/fs/nls/nls_cp437.ko.gz
kernel/net/packet/af_packet.ko.gz
kernel/drivers/misc/vmw_balloon.ko.gz
kernel/drivers/input/serio/serio.ko.gz
kernel/drivers/scsi/sr_mod.ko.gz
kernel/drivers/input/mousedev.ko.gz
kernel/drivers/misc/vmw_vmci/vmw_vmci.ko.gz
kernel/drivers/ata/ata_generic.ko.gz
kernel/drivers/input/serio/i8042.ko.gz
kernel/fs/nls/nls_iso8859-15.ko.gz
kernel/drivers/scsi/sg.ko.gz
kernel/net/unix/unix.ko.gz
kernel/drivers/tty/serdev/serdev.ko.gz
kernel/fs/squashfs/squashfs.ko.gz
kernel/lib/lz4/lz4_decompress.ko.gz
kernel/drivers/cpufreq/cpufreq_powersave.ko.gz
kernel/fs/nls/nls_ascii.ko.gz
kernel/fs/nls/nls_cp850.ko.gz
kernel/net/xfrm/xfrm_algo.ko.gz
kernel/drivers/cpufreq/cpufreq_userspace.ko.gz
kernel/fs/nls/nls_iso8859-1.ko.gz
kernel/net/vmw_vsock/vsock.ko.gz
kernel/drivers/scsi/scsi_transport_spi.ko.gz
kernel/drivers/input/serio/libps2.ko.gz
kernel/drivers/input/vivaldi-fmap.ko.gz
kernel/fs/nls/nls_utf8.ko.gz
kernel/drivers/net/vmxnet3/vmxnet3.ko.gz
kernel/drivers/cdrom/cdrom.ko.gz
kernel/fs/efivarfs/efivarfs.ko.gz
kernel/drivers/scsi/scsi_transport_iscsi.ko.gz
kernel/drivers/input/evdev.ko.gz
kernel/drivers/scsi/scsi_transport_sas.ko.gz
kernel/drivers/input/misc/pcspkr.ko.gz
kernel/drivers/input/mouse/psmouse.ko.gz
kernel/lib/zstd/zstd_common.ko.gz
kernel/drivers/ata/ata_piix.ko.gz
kernel/drivers/rtc/rtc-cmos.ko.gz
kernel/drivers/ata/pata_acpi.ko.gz
kernel/block/t10-pi.ko.gz
kernel/lib/zstd/zstd_decompress.ko.gz
kernel/drivers/block/loop.ko.gz
kernel/drivers/acpi/ac.ko.gz
kernel/drivers/ata/libata.ko.gz
kernel/drivers/cpufreq/cpufreq_ondemand.ko.gz

```
