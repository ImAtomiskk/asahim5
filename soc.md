# SoC Info — Apple M5 (T8142 "Hidra")

## Identification

- **Chip:** Apple M5 (base, not Pro/Max)
- **SoC codename:** T8142
- **Internal codename:** Hidra
- **Device:** MacBook (M5, base model)

## T8xxx Lineage

The base chip lineage is the best supported in Asahi — most driver development targets this series:

| SoC | Codename |
|-----|----------|
| M1  | T8103 |
| M2  | T8112 |
| M3  | T8122 |
| M4  | T8132 (assumed) |
| M5  | T8142 |

T8142 drivers should be based on T8122 (M3 base), not T6030 (M3 Pro). The base chip lineage has:
- More iterations of refinement across hardware generations
- Conservative hardware changes between generations
- Most Asahi users/developers on base hardware = more eyes on code
- GPU work is WIP (not TBA) on T8122, giving a head start

## M3 Base (T8122) Driver Status — Reference for T8142 Porting

| Component | M3 Base Status | Notes |
|-----------|---------------|-------|
| UART | linux-asahi | Likely direct port |
| I2C | linux-asahi | Likely direct port |
| GPIO | linux-asahi | Likely direct port |
| SPI / SPI NOR | linux-asahi | Likely direct port |
| SMC | linux-asahi | Likely direct port |
| SPMI | linux-asahi | Likely direct port |
| RTC | linux-asahi | Likely direct port |
| DART | linux-asahi | Likely direct port |
| PCIe | linux-asahi | Likely direct port |
| NVMe (ANS) | linux-asahi | Likely direct port |
| AICv3 | linux-asahi | Likely direct port |
| cpufreq / cpuidle | linux-asahi | Likely direct port |
| Suspend/sleep | linux-asahi | Likely direct port |
| MCA | linux-asahi | Likely direct port |
| Video Decoder | linux-asahi (no AV1) | Likely direct port |
| DCP (display) | WIP | Active code exists, needs work |
| USB2/3 (TB ports) | WIP | Active code exists |
| DP Alt Mode | WIP | Active code exists |
| GPU | WIP | Active AGX work on T8122 |
| USB-PD | WIP | Active code exists |
| PMU | TBA | No groundwork |
| SEP | TBA | No groundwork |
| Neural Engine | TBA | No groundwork |
| Video Encoder | TBA | No groundwork |
| Thunderbolt | TBA | No groundwork |
| ProRes Codec | TBA | No groundwork |

## Compatible String Strategy

When porting T8122 drivers, add T8142 compatible strings alongside existing ones. Example:

```c
static const struct of_device_id apple_uart_of_match[] = {
    { .compatible = "apple,t8122-uart" },
    { .compatible = "apple,t8142-uart" },  /* add this */
    {}
};
```
