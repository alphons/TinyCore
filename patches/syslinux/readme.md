# syslinux patch for gcc 12.2

I cloned the syslinux repository and changed a few files to get it compiling again against GCC 12.2

## syslinux 6.04
git clone --recursive git://repo.or.cz/syslinux.git syslinuxcurrent

## syslinux 4.07
```
wget https://mirrors.edge.kernel.org/pub/linux/utils/boot/syslinux/syslinux-4.07.tar.xz
tar xf syslinux-4.07.tar.xz
```

# Build environment

- GCC 12.2.0
- GNU libc 2.36
- Nasm 2.15.05
- GNU Make 4.4
- GNU Binutils 2.39
- Python 3.9.4
- XZ Utils 5.4.0
- Perl v5.36.0 (/usr/bin/perl)

# Modified files

```
*       modified:   com32/cmenu/libmenu/cmenu.h
*       modified:   com32/cmenu/libmenu/com32io.h
*       modified:   com32/cmenu/libmenu/menu.c
*       modified:   com32/cmenu/libmenu/syslnx.c
*       modified:   com32/cmenu/libmenu/tui.c
*       modified:   com32/gplinclude/memory.h
*       modified:   com32/hdt/hdt-ata.c
*       modified:   com32/hdt/hdt-cli.c
*       modified:   com32/hdt/hdt-cli.h
*       modified:   com32/hdt/hdt-common.h
*       modified:   com32/lib/getopt_long.c
*       modified:   com32/lib/sys/openmem.c
*       modified:   core/fs/pxe/ftp.c
*       modified:   core/include/core_pxe.h
*       modified:   dos/errno.h
*       modified:   libinstaller/fs.c
*       modified:   libinstaller/setadv.c
*       modified:   libinstaller/syslinux.h
*       modified:   mbr/i386/mbr.ld
*       modified:   mbr/x86_64/mbr.ld
```

# Patch

The result: diff -uprN -X dontdiff syslinuxcurrent/ syslinuxpatched/ > syslinux-gcc12-patches.patch

[syslinux-gcc12-patches.patch](6.04/syslinux-gcc12-patches.patch)

[syslinux-4.07-gcc12-patches.patch](4.07/syslinux-4.07-gcc12-patches.patch)

# Applying patch

```
cd syslinux
patch -p1 < ../syslinux-gcc12-patches.patch
```
