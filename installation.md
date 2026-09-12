# 1.0 - Preparation
## Requirements:
**Apple M5 MacBook Pro (Base M5 Only)**  
**Make (Brew Make - macOS | build-essential - Ubuntu)**  
**Git (built into macOS | build-essential - Ubuntu)**  
**Python 3+ (for proxy mode)**  
**USB C-C Cable (for proxy mode)**  
**Network Connection (Optional If Using USB/SD)**  

## Optional (But Recommended):
**USB Flash Drive / SD Card (4GB Minimum, Optional If Using Internet)**  
**Way to Restore (Another Mac, Ubuntu with libimobiledevice, etc.)**  
**macOS Firmware Dump [(IPSW.me)](https://ipsw.me/product/Mac/) (Recommended to find Day-One Patch, ex: 25A8364)**  
**macOS Backup (From Time Machine, etc.)**  

# 1.1 - Installation
## USB Installation:
Take the m1n1 folder in this directory and place it into a USB drive (preferably root - /Volumes/<YOUR-USB>/)  

Insert the USB Into The MacBook & Reboot Into Recovery Mode (Shutdown -> Hold Power Until Startup Options -> Options)  

<small>Note: Make Sure the "Tools" option in the menu bar has a Recovery Assistant, if not, reboot again until it shows up.</small>

Open Terminal in Recovery Mode (Cmd + Shift + T)  

### Mount USB in recoveryOS:  
```diskutil mount /dev/diskXsY # Replace diskXsY with your USB, Findable with "diskutil list"```  
### Write m1n1 from USB:  
```kmutil configure-boot -c "/Volumes/<USB>/m1n1/build/m1n1.macho" --raw --entry-point 2048 --lowest-virtual-address 0 -v "/Volumes/Macintosh HD - Data"```  

### Reboot Into m1n1