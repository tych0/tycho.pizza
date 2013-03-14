---
title: Unifying Logitech Devices on Linux
date: 2011-12-12
tags: bugfix
---

I was recently given a [Logitech K800 keyboard][1] and a [Logitech
Performance Mouse MX][2], both of which are great devices. I picked
them because wireless-ness is useful for ergonomic reasons, and they
have rechargeable batteries, and you can attach them both to the same
USB input, so you have fewer cables lying around.

Naturally, though, when I unboxed them I found out that you can only
unify them to the same receiver with Windows-only software. There are
a number of other features that are only usable with the Windows-only
software, but I figured there would be a hardware sync process.
Unfortunately, there's not a Logitech supported one.

There is, however, a [community developed one][3]! There's a short C
program with a bunch of magic numbers which send commands to the
device and cause it to unify with a new device. Unfortunately, the
program comes with no directions, so I thought I'd post about how to
do it. First, put the program in `pairing_tool.c`, as suggested in the
post.  Then, compile it with:

    gcc -o pairing_tool pairing_tool.c

To run it, we need to figure out where the Logitech unifying receiver
is. The program wants the hidraw device corresponding to the unifying
receiver. To find this out, you can look in
`/sys/class/hidraw/hidraw*/device/uevent`. In my case, the device is
`hidraw2`, and the output looks like this:
    
    smitten:~$ cat /sys/class/hidraw/hidraw2/device/uevent 
    DRIVER=generic-usb
    HID_ID=0003:0000046D:0000C52B
    HID_NAME=Logitech USB Receiver
    HID_PHYS=usb-0000:00:1a.0-1.4/input2
    HID_UNIQ=
    MODALIAS=hid:b0003v0000046Dp0000C52B

So, we can now unify the devices with the following command:
    
    sudo ./pairing_tool /dev/hidraw2

And then power on your device as the tool tells you to. I think
there's some timeout on this, because the first time I did it I waited
a few minutes and then powered on the device, and it didn't work. So,
have your device ready and do it seconds after you run the pairing
tool, and it should all work fine. HTH!

  [1]: http://www.amazon.com/Logitech-Wireless-Illuminated-Keyboard-K800/dp/B003VAGXWK/
  [2]: http://www.amazon.com/Logitech-Wireless-Performance-Mouse-Mac/dp/B002HWRJBM
  [3]: http://groups.google.com/group/linux.kernel/msg/36c53d79832fc3f5
