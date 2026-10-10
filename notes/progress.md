# M5 Bringup Progress

## Checklist

* Compile m1n1 ✔
* Install m1n1 ✔
* Boot m1n1 (proxy mode) ✔
* Dump Essential Files ✔
* Boot m1n1 (hypervisor/guest mode) ✔ (it mostly works, so I'll count it for now)
* Launch U-Boot (Das U-Boot: https://github.com/u-boot/u-boot) --
* Make Drivers ❌
* Boot Linux (for real) ❌ - About 80-90% There
* Linux Working ❌

## Roadmap

**Year 1** — Fix proxy/hypervisor mode, map T8142 memory layout, port easy drivers (UART, I2C, GPIO etc), get to bootable shell

**Year 2** — Display via DCP port, USB, basic desktop, video playback, code editing usable


## End Goal

A fully usable Linux system on M5 capable of:
- Code editing
- Watching videos (hardware decode preferred)
- Playing games (requires Vulkan/GPU)
- Emulators (CPU-bound ones early, GPU-dependent ones after GPU work)
- Video editing (optional, last milestone — depends on hardware encoder which is TBA)
