# M1N1 Installation Guide (Apple M5 / T8142)

---

# 1.0 - Preparation

## Requirements

**Apple MacBook (Base M5 / T8142 "Hidra")**  
**Make** — `brew install make` (macOS) | `sudo apt install build-essential` (Ubuntu)  
**Git** — built into macOS | `sudo apt install git` (Ubuntu — not included in build-essential)  
**Python 3+** — for proxy mode (`brew install python3` / `sudo apt install python3 python3-pip`)  
**USB-C to USB-C Cable** — for proxy mode connection

## Optional (But Recommended)

**USB Flash Drive or SD Card** — 4GB minimum, for offline installation  
**Recovery method** — another Mac with Apple Configurator 2, or Ubuntu with libimobiledevice (see recovery.md)  
**macOS Firmware IPSW** — download from [ipsw.me](https://ipsw.me/product/Mac/) — recommended to save a day-one build (e.g. 25A8364) before updating  
**macOS Backup** — Time Machine or equivalent before starting

## Disable FileVault
Head To Privacy & Security in System Settings (Apple Logo -> System Settings)
![](https://cdn.discordapp.com/attachments/1412862335701487780/1549142541650100274/Skjermbilde_2026-09-14_kl._3.38.20_pm.png?ex=6aa99eeb&is=6aa84d6b&hm=796b0d6f6c91f76fe51359ef1a865c5d4aa5f16c8111375424de7a1486d92bbd&)

Then Go Into FileVault
![](https://cdn.discordapp.com/attachments/1412862335701487780/1549142741882249277/Skjermbilde_2026-09-14_kl._3.39.09_pm.png?ex=6aa99f1b&is=6aa84d9b&hm=733ff69dcd46cce40d47c2f852dedc67d5942d8efe26ff6626a13b59bdc67595&)
and Flick the Toggle **Off**

---

# 1.1 - Compiling m1n1

Build m1n1 on a Mac or Linux machine before putting it on the USB. Do not attempt to compile in recoveryOS.

## On macOS

```bash
# Install dependencies
brew install make python3 gcc-aarch64-embedded

# Clone m1n1
git clone --recursive https://github.com/AsahiLinux/m1n1
cd m1n1

# Compile
make -j$(sysctl -n hw.ncpu)
```

## On Ubuntu / Debian Linux

```bash
# Install dependencies
sudo apt install build-essential git python3 python3-pip gcc-aarch64-linux-gnu

# Clone m1n1
git clone --recursive https://github.com/AsahiLinux/m1n1
cd m1n1

# Compile
make -j$(nproc)
```

After a successful build, `build/m1n1.macho` and `build/m1n1.bin` will be present. Both are needed — `.macho` for installation, `.bin` for proxy/hypervisor mode.

## Preparing the USB Drive

Copy the entire m1n1 folder to the root of a USB drive:

```
/Volumes/<YOUR-USB>/
└── m1n1/
    └── build/
        ├── m1n1.macho
        ├── m1n1.bin
        └── (other build artifacts)
```

Keeping the full m1n1 folder (not just the build output) is recommended — you'll want the proxyclient scripts later.

---

# 1.2 - Installation

## Entering recoveryOS

1. Shut down the MacBook completely
2. Hold the power button until "Loading startup options..." appears
3. Click **Options** → **Continue**
4. Select your user and enter your password if prompted

> **Important:** Check the menu bar — the **Tools** menu must contain **Recovery Assistant**. If it's missing, quit and reboot into recoveryOS again. Recovery Assistant confirms you are in 1TR (One True Recovery), which is required for `kmutil configure-boot` to work. Without 1TR, the command will fail silently or with a permissions error.

## Opening Terminal

Press **Cmd + Shift + T**, or go to **Utilities → Terminal** in the menu bar.

## USB Installation

### 1. Find your USB drive

```bash
diskutil list
```

Look for your USB drive in the output — it will show up as something like `/dev/disk2` with a partition like `/dev/disk2s1`. Note the full partition path.

### 2. Mount the USB

```bash
diskutil mount /dev/diskXsY  # replace diskXsY with your USB partition
```

Verify it mounted:

```bash
ls /Volumes/  # your USB name should appear here
```

### 3. Write m1n1
**macOS 12.0 or Higher**
 ```bash
kmutil configure-boot \
  -c "/Volumes/<YOUR-USB>/m1n1/build/m1n1.bin" \
  --raw \
  --entry-point 2048 \
  --lowest-virtual-address 0 \
  -v "/Volumes/Macintosh HD - Data"
``` 

**macOS 11.0 or Lower**
```bash
kmutil configure-boot \
  -c "/Volumes/<YOUR-USB>/m1n1/build/m1n1.macho" \
  --raw \
  --entry-point 2048 \
  --lowest-virtual-address 0 \
  -v "/Volumes/Macintosh HD - Data"
``` 

Replace `<YOUR-USB>` with your actual USB volume name. If your data volume has a different name, adjust accordingly — use `diskutil list` to confirm.

A successful write produces no error output. If you see a permissions error, you are not in 1TR — reboot into recoveryOS and try again.

### 4. Reboot into m1n1

```bash
reboot
```

The MacBook will reboot. Instead of the normal Apple logo boot sequence, the screen will show a asahi logo, go dark then show some logs  — this is normal. m1n1 is running.

---

# 1.3 - Verifying Proxy Mode

## Connect via USB-C

Connect your MacBook to a Linux or Windows machine via USB-C to USB-C cable.

On Linux, m1n1 exposes a serial device:

```bash
ls /dev/ttyACM*  # should show /dev/ttyACM0
```

On Windows, check Device Manager for a new COM port (e.g. COM3).

## Install Python dependencies

```bash
cd m1n1
pip3 install -r proxyclient/requirements.txt
```

## Set the port

```bash
export M1N1_PORT=/dev/ttyACM0  # Linux
# or
set M1N1_PORT=COM3  # Windows CMD
```

## Connect

```bash
python3 proxyclient/tools/shell.py
```

If proxy mode is working you will get a Python shell prompt. You can then run basic commands:

```python
>>> p.chip_id()  # should return T8142 chip identifier
>>> p.read32(0x...)  # read a register
```

> **Known Issue (T8142):** All proxy read commands currently return zeros. This is a known base address drift issue — the proxy client has M1/M2 era MMIO addresses hardcoded that do not match T8142. See `proxy-hypervisor.md` for details and next steps. Connection itself working is a success.

---

# 1.4 - Troubleshooting

### `kmutil configure-boot` fails with permissions error
You are not in 1TR. Reboot into recoveryOS and check that Tools → Recovery Assistant is present before running the command.

### USB drive not showing up in recoveryOS
Try a different USB-C port. recoveryOS can be picky about which controller is active. Also try `diskutil list` to check if it's visible but not mounted.

### m1n1 doesn't appear to boot (normal Apple boot instead)
The `kmutil` write may have failed silently. Re-enter recoveryOS and repeat the installation steps. Verify the path to `m1n1.macho` was correct.

### `/dev/ttyACM0` doesn't appear on Linux
- Try a different USB-C cable — not all cables carry data
- Try a different port on the host machine
- Check `dmesg | tail` after connecting for USB enumeration errors
- Make sure you are not in a VM without USB passthrough configured (see `proxy-hypervisor.md`)

### Permission denied on `/dev/ttyACM0`
```bash
sudo usermod -aG dialout $USER
# log out and back in, then retry
```

### Proxy shell connects but all reads return 0
Known T8142 issue. See `proxy-hypervisor.md`. Connection is working correctly — this is a client-side address mismatch, not a hardware problem.