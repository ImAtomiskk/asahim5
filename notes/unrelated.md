# Other Stuff That Happened During Asahi

## M5 Firmware Wipe Incident

### What happened
Selected "Macintosh HD" in Disk Utility from recoveryOS and clicked Erase. Normally macOS prompts "this is the main drive, do you want to reset your Mac instead?" — this prompt never appeared and Disk Utility erased the entire disk including firmware and recoveryOS/1TR.

### Why it happened
Unknown exactly. Likely the system state (modified by prior tinkering) caused Disk Utility to not recognize the volume as the startup disk, so it treated it as a regular volume and erased without the safety prompt.

### Reproducibility
Probably reproducible under the same system conditions. Worth documenting exactly what state the system was in beforehand if attempted again. **Do not test on the M5 currently being used for bringup work.**

### Recovery method
Recovered without a second Mac using Linux and libimobiledevice. Total time: ~6 hours (2-3 hours excluding VMware dead end).

**Key steps (approximate — exact commands not saved):**
1. Attempted VMware first — failed, USB timing too unreliable for DFU through VM
2. Switched to bare metal Linux with libimobiledevice
3. Used some injection method to force DFU mode (exact method forgotten — research this before next incident)
4. libimobiledevice handled the actual firmware restore cleanly once in DFU
5. Most time was spent getting into DFU mode reliably

**Note:** Getting into DFU without working recoveryOS is the hard part. The button sequence timing on Apple Silicon is very finicky. There is an injection method that forces the DFU state transition — this needs to be documented before it's needed again.

## M2 Firmware Wipe Incident

### What happened
Caused by attempting to install Asahi Linux on M2 MacBook.

### Recovery method
Used a second Mac + Apple Configurator 2 + help from a friend. Standard DFU restore path.

## No Security Mode

Removed from recoveryOS somewhere between macOS 26.4.x and 27 Developer Beta. May be M5-specific rather than a broad policy change — needs verification on older hardware.

**Workaround:** Still have a signed IPSW dating back to macOS 26.0 (saved for ~2 months). If 26.0 recoveryOS still has No Security mode and Apple is still signing it, this is a potential foothold. Check ipsw.me for signing status. **Time sensitive — Apple stops signing old IPSWs quickly.**

## DFU Notes

- Apple Silicon DFU without working recoveryOS requires either: second Mac + Apple Configurator 2, OR Linux + libimobiledevice + injection to force DFU state
- VMware is unreliable for DFU due to USB timing sensitivity — go straight to bare metal Linux
- Once in DFU, the actual restore via libimobiledevice is straightforward
- Getting into DFU is the hard part — find and document the injection method used

## Signed IPSWs

Have macOS 26.0 IPSW saved locally. Useful for:
- Accessing No Security mode in recoveryOS (if present in 26.0)
- Downgrade path for Nugget/PosterBoard wallpapers if needed
- Emergency recovery baseline

## m1n1 Installation

- Installed via recoveryOS
- Boots directly into proxy mode on USB connection (default behavior)
- Serial output available over `/dev/ttyACM0`
- Boot log prints real M5 memory map — always capture this with picocom when available
