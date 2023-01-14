# isobuilder

Script for making a new tinycore64 iso.

Also included .config files for different kernels.

What it does is;
- getting the current TinyCore64 iso
- getting the new linux kernel sources (kernel.org)
- extracts iso
- compiles kernel
- compiles modules
- installs new kernel and modules
- creates new iso

The used .config files are made minimal, they contain a few modules, mostly externel kernel and for runnng in a vmware/esxi world.

Best is to do the r option ( make menuconfig) and add all the stuff you need.

There are NO patches applied to the sources.
