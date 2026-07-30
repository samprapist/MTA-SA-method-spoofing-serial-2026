# MTA:SA Serial Number Spoofing Method

I'm sharing a method for spoofing serial numbers in MTA:SA. It's my own method, developed based on publicly available projects. It's probably the only publicly available and free method available today, as I couldn't find a thread that would allow it. 😈

**The method definitely work, I checked it several times.**

If you managed to change your serial number, give me reputation in return:
![reputation](https://i.imgur.com/BW93jt2.gif)

Below I am including all the sources I used:

```php
Use temp-spoofer from my attachment because it is modified
https://www.unknowncheats.me/forum/anti-cheat-bypass/742461-windows-kernel-driver-temp-spoofer.html
github kdmapper
github MAC-Address-Spoofer
github HWIDInspector
and others
```

### Additional software required:

```text
Python
Visual studio 2022
WDK and SDK 26100.6584 or other
```

### Advantages and disadvantages of the following method:

```text
+ It does not require a disk format, although you can probably skip some steps in this method by formatting it.

+ Permanent, new SERIAL, you can freely set the random seed to generate a new one or keep the old one

+ It's free but time-consuming

- Requires creating a new user account and deleting the old account, as well as transferring AppData, which may cause problems

- There is no 100% certainty that this method removes all traces

- It requires some intermediate knowledge, for those who don't know much I think they will be able to handle the AI chat.
```

### **Dangers of this method:**

```text
- Post some user in original temp spoofer thread mentioned the possibility of system corruption, which requires formatting, but that likely relates to EFI spoofing, which is disabled by default in the spoofer solution. In any case, I didn't have this problem when spoofing a disk in a VM or locally, but take this as a warning.

- Possibility of damaging program data stored in the Appdata folder

- BSOD

Possible minor Windows errors. So far, I've encountered:

- A slow right-click context menu is caused by a program remaining in the registry that doesn't exist but was previously in appdata. This can be easily fixed with shellview.

- The Start Menu sometimes crashes, only if you loading a driver using kdmapper. You can still use the system after the crash, but without the Start Menu. It resolves after a restart.

- Windows accounts disappear upon login; you can only log in with the main account. This resolves after enabling a special administrator account and setting a password for that account in cmd.

- Trouble finding various options in the Start Menu. For example, I can't open Folder Options, but I can open them with Win+R.

- Most of these problems can probably be avoided by using a registry backup of the most important system keys.
```

### TODO

```text
- For some reason, sometimes the old serial number remains at the beginning until we connect to the server, this may mean that not all traces have been removed!

- Find all the traces after using MTA, exact methods of obtaining the serial number through MTA so as not to make unnecessary steps

- Getting rid of unnecessary steps from the method?

- Fix registry and mac spoofing functions in temp-spoofer, add spoofing options like in HWIDInspector

- Introduce GPU spoofing capability for AMD and other parameters

- Creating one solution in exe format, spoofing the serial number with one click and the ability to set the serial

- Instead of using a spoofer, create code that can infect MTA and replace all serial numbers in packets and overwrite MTA functions that query the system for hardware identifiers 

- Check if this method will effectively avoid GLOBAL BAN in MTA, if not, find out why it doesn't work and fix it

- Modify the spoofer to make it undetectable
```

**By:** `thorus.m47k0j3bc4`
