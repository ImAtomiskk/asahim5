# Recovery
### What To Do if You See This
![](https://cdsassets.apple.com/live/7WUAS350/images/macos/macos-startup-exclamation-mark-in-circle.png)
If Your Computer Starts Up To An Exclamation Circle, Here's What to Do
> 🍎 Apple Description:  
> In very rare circumstances, such as when a power failure interrupts macOS installation, your Mac might start up to a circled exclamation point. This means that the firmware stored in your computer's memory needs to be revived or restored.  

> ⚠️ **WARNING**:  
> If Your Device Gets To This Point, You Have Lost All of Your Data, Unless You Use Drive Recovery Software (Disk Drill, etc.)

## 1.0 - Preparation
### Requirements:
* **Mac OR Ubuntu Computer with libimobiledevice + idevicerestore**  
* **USB C-C Cable**

> Install Restore Software (Ubuntu Only):  
> ```
> sudo apt update
> sudo apt install libimobiledevice idevicerestore
> ```

## 1.1 - DFU Port/Mode
> 🍎 Apple Description:  
> For certain tasks, such as reviving or restoring firmware or installing macOS on an external storage device, you need to know the location of your computer's DFU (device firmware update) port. Only a Mac with Apple Silicon or Mac with the Apple T2 Security Chip has this DFU port, which looks identical to other ports that accept a type USB-C connector.

### Find Your DFU Port Here:
>https://support.apple.com/en-us/120694  
> Example: For a MacBook Pro M5, it would be here (Excuse the older model):
> ![](https://cdsassets.apple.com/live/7WUAS350/images/mac-os/sonoma/t2-macbook-pro-left-side-ports-rightmost-usb-c-port-location-illustration.png)

### How to Enter DFU Mode:
1. Connect The Two Computers Together Using a USB C-C Cable (Make Sure **No** MagSafe Power Cables Are Connected)

2. Press and hold the power (Touch ID) button for up to 10 seconds, until the Mac turns off. If the Mac turns on instead, repeat this step.

3. Press and release the power button, then immediately press and hold all four of these together on the built-in keyboard:

    * Control ⌃ on the left side of the keyboard

    * Option ⌥ on the left side of the keyboard

    * Shift ⇧ on the right side of the keyboard

    * Power button  
![](https://cdsassets.apple.com/live/7WUAS350/images/mac-os/sonoma/macbook-pro-keyboard-dfu-mode-startup-keyboard-combination-diagram.png)
4. Mac laptop with Apple Silicon:  

   * Keep holding all four keys for about 10 seconds, then release all keys—except the power button.
   * Keep holding the power button for up to 10 more seconds, until the host Mac shows a DFU window in the Finder. If it first shows an alert asking you to allow the accessory to connect, release the power button and click Allow.  

5. Mac laptop with T2 chip:  
   * Keep holding all four keys for about 3 seconds, until the host Mac shows a DFU window in the Finder. If it first shows an alert asking you to allow the accessory to connect, release all keys and click Allow.   
6. The affected Mac is now in DFU mode and should show a blank screen. Follow the steps below to restore.

## 2.0 - Restore
### macOS Instructions:
1. Open Finder On The Working Computer
2. Select The Affected Mac
3. Click Revive (If Available), otherwise, click Restore
![](https://cdsassets.apple.com/live/7WUAS350/images/macos/tahoe/macos-tahoe-26-finder-locations-mac-connected-dfu-mode-revive-restore.png)
4. Wait for it to finish

### Linux Instructions:
**Option 1 (Recommended)**
1. Download Your macOS IPSW at [IPSW.me](https://ipsw.me/product/Mac)
2. Run The Restore Command in Your Terminal:  
``sudo idevicerestore -e <Path-To-Your-IPSW>``  

**Option 2**
1. Run The Restore Command in Your Terminal:  
``sudo idevicerestore -e -l``
2. Select Your Image Version

![](https://i.imgur.com/xjmQ0W4.png)  
> When You See This Screen, Type YES then Press ENTER


## After That, You're Restored