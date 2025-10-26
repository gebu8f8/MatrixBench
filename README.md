# MatrixBench (MB) — Server "integrity" testing expert

[繁體中文](https://github.com/gebu8f8/MatrixBench/blob/main/README_zh.md) | [简体中文](https://github.com/gebu8f8/MatrixBench/blob/main/README_cn.md)

This isn't just another benchmark script; it's a **server health diagnostic tool** designed to transform vague "stuttering" into clear, objective data.

The heart of `MatrixBench` lies in its unique **CPU Integrity Test**, which analyzes `Steal Time` and `Kernel Latency` to help you determine whether your VPS is performance-hacked or severely oversold.

## Key Features

*   **Diagnoses CPU Integrity:** Unveils true server stability by analyzing `Steal Time` and kernel latency, going beyond standard benchmarks.
*   **Benchmarks Your Entire System:** Assesses CPU (SysBench & GeekBench 6), memory, and disk I/O performance.
*   **Generates Sharable Reports:** Instantly creates beautiful, graphical reports for IP quality, network performance, and streaming unlock tests.
*   **Tests Global Streaming Access:** Checks unblocking capabilities for major streaming platforms across different regions.
*   **Reveals Network Quality:** Provides a complete picture of your network with global speed tests, latency checks, and backhaul routing analysis.

## Quick Start

Run the command below to perform a full system benchmark. Dependencies will be installed automatically.

```bash
bash <(curl -sL https://mb.g gebu8f.com) -l en
```
> **Note:** The first run may take some time as the script installs necessary tools like `curl`, `jq`, and `wkhtmltoimage`. An IPv4 connection is required for all tests to run correctly.
## Options and parameters
By default, MatrixBench performs a comprehensive analysis. Use the following options to run specific tests and save time.

| Option | Description |
| :---: |:--- |
|`-l <lang>`| Set the script language (`cn` for Simplified Chinese, `en` for English, leaving it unselected is Traditional Chinese) |
|`-hw`| **Full Hardware Audit:** Runs all hardware tests, including benchmarks, CPU topology, and our exclusive **CPU Honesty Test**.|
|`-oversell`| **CPU Honesty Test:** Our exclusive test to see if you're getting the CPU you paid for. |
| `-ip`        | Performs an in-depth IP quality analysis.                   |
| `-nq`        | Checks network quality and backhaul routing.                |
| `-stream`    | Tests unblocking capabilities for major streaming services. |
| `-speedtest` | Runs global network speed tests with Speedtest.net.         |
| `-ping`      | Measures network latency with multiple Ping tests.          |
| `-stability` | Assesses network stability with a high-traffic download test. |
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

