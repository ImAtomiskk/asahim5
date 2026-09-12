# Proxy Mode & Hypervisor Mode

## Current Status

- USB serial connection works (`/dev/ttyACM0`)
- Mac recognizes the connection
- **Problem: all proxy commands return zeros**
- Root cause: suspected base address drift — proxy client has M1/M2 era MMIO base addresses hardcoded, M5 has likely shifted these

## Why Zeros

m1n1 proxy client hardcodes MMIO base addresses in `proxyclient/hw/`. On M5 these addresses have likely shifted from what the client expects. The client reads from the wrong address, gets zeros (unmapped or zero-mapped region), and returns them silently instead of crashing.

## Immediate Next Steps

### 1. Capture the m1n1 boot log (priority)

Before fixing anything, capture the real M5 memory map that m1n1 prints at boot via picocom:

```bash
picocom -b 115200 /dev/ttyACM0 | tee m5_boot_log.txt
```

This gives ground truth base addresses for all peripherals without going through the broken proxy client. Save this file — it's the foundation for everything else.

### 2. Cross-reference boot log against proxy client constants

Compare addresses in the boot log against hardcoded values in `proxyclient/hw/`. Identify what shifted on M5.

### 3. Anchor on UART first

UART is a good starting point since it's already active (serial works). Find UART base in boot log, update `proxyclient/hw/` to match, verify `p.read32` returns something nonzero.

### 4. Check if offset is uniform

If all peripherals shifted by the same offset, patching the base once fixes everything. If Apple scrambled addresses per-peripheral, it's more tedious but still tractable.

## Hypervisor Mode

Hypervisor mode runs a second m1n1 instance on top of the first, tracing all MMIO accesses as the firmware boots. This gives a complete hardware register access log — the primary tool for reverse engineering M5 peripherals.

### How it works

- m1n1 acts as a thin shim between firmware and hardware
- Every MMIO read/write traps into m1n1, gets logged, then passes through
- Guest (firmware/macOS) runs at native speed — no emulation
- Output comes over serial

### Setup

```bash
# From m1n1 repo root, with proxy connected:
export M1N1_PORT=/dev/ttyACM0
python3 proxyclient/tools/run_guest.py m1n1.bin
```

The hypervisor scripts live in `proxyclient/hv/`.

### Chicken-and-egg problem

`run_guest.py` needs proxy client to work well enough to transfer the payload. Since proxy returns zeros, this may fail. Try it anyway — the failure output might be informative. If it fails, fixing the proxy client base addresses (step 3 above) is the prerequisite.

## Connection Setup

- **Interface:** USB serial (CDC ACM)
- **Device path:** `/dev/ttyACM0` (Linux), `COMx` (Windows)
- **Environment variable:** `export M1N1_PORT=/dev/ttyACM0`
- **Tested on:** bare metal Ubuntu (zeros), VMware Arch Linux VM (untested, next to try)
- **Windows/WSL:** requires usbipd to pass USB through to WSL, or use Python proxy client directly on Windows with pyserial

## Useful Files in m1n1 Repo

| File | Purpose |
|------|---------|
| `proxyclient/tools/shell.py` | Basic proxy shell |
| `proxyclient/tools/run_guest.py` | Launch hypervisor/guest mode |
| `proxyclient/tools/pmgr_adt2dt.py` | ADT to device tree conversion |
| `proxyclient/hw/` | Hardcoded MMIO base addresses — fix these for M5 |
| `proxyclient/hv/` | Hypervisor mode scripts |
| `proxyclient/adt.py` | Dump and diff Apple Device Tree |
