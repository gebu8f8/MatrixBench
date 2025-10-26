# MatrixBench (MB) — Server "integrity" testing expert

[繁體中文](https://github.com/gebu8f8/MatrixBench/blob/main/README_zh.md) | [简体中文](https://github.com/gebu8f8/MatrixBench/blob/main/README_cn.md)

This isn't just another benchmark script; it's a **server health diagnostic tool** designed to transform vague "stuttering" into clear, objective data.

The heart of `MatrixBench` lies in its unique **CPU Integrity Test**, which analyzes `Steal Time` and `Kernel Latency` to help you determine whether your VPS is performance-hacked or severely oversold.

## Key Highlights

* **Exclusive CPU Integrity Test (Core Function):** In-depth analysis of `Steal Time` and core latency under stress, objectively evaluating the server's true stability.
* **Comprehensive Hardware Performance Assessment:** Comprehensive benchmarks covering CPU (SysBench & GeekBench 6), memory, and disk I/O.
* **IP and Network Quality Report:** Generate a one-click graphical report analyzing IP quality, global network speed, latency, and backhaul routing.
* **Streaming Unblocking Capability Test:** Quickly test a server's ability to unblock major streaming platforms. * **Automated graphic and text reports:** All complex test results will eventually generate images and structured text that are easy to share and save.

* ## Quick Start

Execute the following command to start a comprehensive health check. The script will automatically install the required dependencies.

```bash
bash <(curl -sL https://mb.gebu8f.com) -l en
```
> **Note:** When running for the first time or the server environment is very simple, the script will automatically install the necessary tools (such as `curl`, `jq`, `wkhtmltoimage`, etc.), which may take some time. **IPV6 only** requires at least ipv4
## Options and parameters
By default, the script executes all tests. You can use the following parameters to run specific test modules to save time.

| Parameter | Description |
| :---: |:--- |
|`-l <lang>`| Set the script language (`cn` for Simplified Chinese, `en` for English, leaving it unselected is Traditional Chinese) |
|`-hw`| **Hardware-specific:** Run all hardware-related tests (basic information, benchmarks, CPU topology, CPU integrity) |
|`-oversell`| **Core diagnostics:** **Only run** exclusive CPU integrity and topology analysis |
|`-ip`| **IP-specific:** Run only IP quality testing |
|`-nq`| **Network-specific:** Run only network quality (backhaul) testing |
|`-stream`| **Streaming-specific:** Run only streaming unblocking tests |
|`-speedtest`| **Speedtest-specific:** Run only global Speedtest speed tests |
|`-ping`| **Latency-specific:** Run only the Ping latency test |
|`-stability`| **Stability-specific:** Run the aria2c high-speed download stability test |
### Usage Examples

* **Just want a quick check to see if the CPU is oversold?**
```bash
bash mb.sh -oversell
```
* **Want a comprehensive hardware and network review, but don't care about streaming?**
```bash
bash mb.sh -hw -ip -speedtest -ping
```
* (You can freely combine multiple parameters)*
## 📦 Test Results

After all tests are completed, the generated image reports (.png) and text reports (.txt) will be saved in the `result` folder in your home directory (`$HOME/result`).

```
/root/
└── result/
    ├── base.png
    ├── IP.png
    ├── net.png
    ├── hardware.txt
    ├── global_net.txt
    └── report.txt
```
## 🚀 Set as a system command (recommended)

For ease of use, you can run the following command to install `MatrixBench` as a global `mb` command. This command will automatically stay up to date.

```bash
bash <(curl -sL https://mb.gebu8f.com) --install
```
## Detailed information and article (Traditional Chinese)
https://www.gebu8f.com/matrixbench/
## 🙏 Acknowledgements

The successful development of this project would have been impossible without the following excellent open source projects and authors. We would like to express our sincere gratitude. `MatrixBench` builds on their foundation, focusing on providing deeper diagnostic analysis.

* **[yabs.sh](https://github.com/masonr/yet-another-bench-script):** Provides the industry-standard Geekbench and disk performance testing engine.
* **[spiritLH/ecs](https://github.com/spiritLH/ecs):** Commonly known as the "fusion monster", our system information display and sysbench logic functions are deeply inspired by it.
* **[xykt (@MoeClub)](https://github.com/MoeClub):** Their [IP.Check.Place](https://ip.check.place/) (`IPQuality`) and [Net.Check.Place](https://net.check.place/) (`NetQuality`) scripts provide powerful core support for IP and network quality analysis in this project.
* **[lmc999/RegionRestrictionCheck](https://github.com/lmc999/RegionRestrictionCheck):** provides powerful core support for our streaming media detection.

