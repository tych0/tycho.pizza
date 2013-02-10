---
title=How to reformat your cheap MP3 player on Linux
date=2008-07-19
---

I own a MEElectronics MiniMee 2GB MP3 player; I've had this player for quite a
while now, and it works well with Kubuntu. The little player can only play MP3
files, so you'll have to convert everything to MP3 before you put it on the
player. This is a minor inconvenience, but using the Transkode script for
Amarok (available through the script manager), you can tell Amarok to do the
* -> MP3 conversion on the fly, so you only have to press the "Transfer"
button and Amarok will figure out the rest for you (which is nice). 

However, inevitably something will go wrong. I'm not sure where my issue was
(with the MiniMee or with my USB Mass Storage drivers), but I unplugged the
MiniMee without "Safely Remove"ing it. This corrupted the FAT(S), and hosed the
disk. I could still write to it and read from it, but my previous files were
unplayable and invisible (however the MiniMee knew they were there, because it
still reported the storage as in use). That's really the reason I'm posting
this: to tell you how to fix that problem. This was targeted at people with
MiniMees, but it should work for anyone who's got a corrupted mass storage
device (and still needs the hardware to work with Windows, or in the MiniMee's
case the firmware already on the chip). 

First, you'll need mkfs (or more specifically, mkfs.vfat). This is available in
the package [dosfstools][1] which is probably already installed on Ubuntu, but
is simply available with a 

    sudo apt-get install dosfstools

Next, you'll need to find out the device name of the drive with the corrupted
FAT table. There are a million ways to do this, so I'll not go into detail. In
my case it was simple since the device was still autodetected and would mount
properly. In this example, I'll use /dev/sdc but you should replace that with
your block device. You can probably make a good guess/sanity check as to what
your drive letter will be, though, since sd* stands for SCSI device. This
generally includes SATA drives, USB drives, etc. In my case, I have two SATA
drives installed, so my drive letter checks out. 

Anyways, once you know the drive letter, simply open a terminal and issue

    sudo mkfs.vfat -F 16 -I /dev/sdc

The -F 16 option tells mkfs to make a FAT16 partition. The MiniMee seems to
only work with FAT16 partitions (I tried FAT12 and FAT32 for grins and it would
tell me how much data was on the partitions, but it wouldn't play any songs).
Once you're done with the formatting (this should only take a few seconds on
the MiniMee), you can re-transfer your songs and all should be happy.

 [1]: http://packages.ubuntu.com/hardy/dosfstools
