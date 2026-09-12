# Driver Notes

## General Strategy

M5 drivers are almost certainly evolutionary changes from M4/M3, not redesigns. Apple iterates hardware, especially on the base chip lineage. The approach:

1. Take the closest Asahi driver (T8122 for T8142)
2. Add T8142 compatible strings
3. Update any hardcoded register addresses from MMIO traces
4. Fix panics/misbehavior
5. Iterate

## RE Approach

- **Primary tool:** m1n1 hypervisor MMIO tracing — run real macOS/firmware and log every hardware register access
- **Secondary:** XNU source (open source kernel core, useful for understanding kernel interfaces)
- **Not useful directly:** Apple kexts/DriverKit extensions (closed blobs, Mach-O format, IOKit ABI — can't load on Linux)

XNU is open source but the actual hardware drivers (kexts) are closed blobs. You can observe what they do via MMIO tracing but can't port the code.

## Porting from macOS Kexts (Personal Use Only)

For personal hobby use, extracting kext behavior is fine. The technical blockers to running blobs directly on Linux:

- **Binary format mismatch** — macOS kexts are Mach-O binaries built against IOKit/DriverKit APIs. A compatibility layer would need to: parse Mach-O, stub IOKit/DriverKit calls with Linux equivalents, handle macOS memory management assumptions
- **Architecture assumptions** — kexts assume macOS kernel internals, threading model, memory layout
- **Performance** — not a major concern on same architecture (ARM64→ARM64), API stub overhead is negligible since drivers mostly wait on hardware. Memory model bridging (DMA, IOMMU) is the real challenge

The clean approach: use MMIO traces from real hardware to write a native Linux driver. No Apple code, no compatibility layer needed.

## Driver Testing Workflow

1. Develop/test driver in m1n1 guest/hypervisor mode — crash kills guest not system
2. Use VFIO to pass specific hardware to a Linux VM for more realistic testing
3. Promote to bare metal when stable

## Specific Driver Notes

### Storage (ANS NVMe)
Not standard NVMe. Soldered to SoC, goes through Apple's ANS2/ANS3 controller. Linux's native `nvme` driver won't work. Asahi wrote a custom ANS driver — port this for T8142.

### WiFi (Broadcom brcmfmac)
BCM4387 or similar. Linux has `brcmfmac` but Apple uses custom firmware and nonstandard PCIe attachment. Asahi has working WiFi on M1/M2 via patched brcmfmac. Speed doesn't need to be optimal — just working is the goal. Port Asahi's brcmfmac patches for T8142.

### Display (DCP)
Apple's display coprocessor. WIP on T8122, complex driver involving proprietary firmware. One of the harder ports. Basic framebuffer may work earlier than full DCP.

### GPU (AGX)
The longest pole. Asahi's AGX driver (with Vulkan via HoneyKrisp) took years on M1/M2. WIP on T8122 gives a head start. M5 GPU may have architectural changes needing new RE work. Required for: games, GPU-dependent emulators, Vulkan, video editing acceleration.

### Parallels Tools (Reference Only)
Parallels Tools are open source Linux ARM64 drivers but target Parallels virtual hardware, not real Apple Silicon. Useful as reference/skeleton for:
- Display/framebuffer driver structure
- Input handling patterns
- Host/guest communication channel design

Not useful for: SMC/ACPI (fake hardware), network (virtual NIC), storage (virtual block device).

### Video Decoder
Already in linux-asahi for M3 base (no AV1). Likely straightforward port for T8142. Unblocks video playback early without needing GPU.

### Video Encoder
TBA across all M3 variants. Long way off. Not blocking for initial goals.
