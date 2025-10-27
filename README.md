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
bash <(curl -sL https://mb.gebu8f.com) -l en
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
## Usage Examples

*   **To check for CPU overselling:**
    ```bash
    bash <(curl...) -oversell
    ```
*   **For a full hardware and network audit (excluding streaming tests):**
    ```bash
    bash <(curl...) -hw -ip -nq -speedtest -ping
    ```
*   **To test only IP quality and streaming access:**
    ```bash
    bash <(curl...) -ip -stream
    ```
*(Options can be combined freely.)*

## 📦 Test Results

Upon completion, all generated reports—including images (`.png`) and text summaries (`.txt`)—are saved to the `$HOME/result` directory.

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
## 🚀 Install as a Global Command

To run `MatrixBench` from anywhere, install it as a global `mb` command. It will automatically keep itself updated.

```bash
bash <(curl -sL https://mb.gebu8f.com) --install
```
## Detailed information and article (Traditional Chinese)
https://www.gebu8f.com/matrixbench/
## 🙏 Acknowledgements

MatrixBench stands on the shoulders of giants. We extend our sincere credit to the following projects and authors for their foundational work:

*   **[yabs.sh](https://github.com/masonr/yet-another-bench-script):** For its robust Geekbench performance testing engine.
*   **[oneclickvirt/ecs](https://github.com/oneclickvirt/ecs):** Whose "ECS" approach inspired our system information display, sysbench and disk test logic.
*   **[xykt](https://github.com/xykt):** For the powerful IP (`IPQuality`) and network (`NetQuality`) quality analysis scripts.
*   **[lmc999/RegionRestrictionCheck](https://github.com/lmc999/RegionRestrictionCheck):** For providing the core engine for our streaming unlock tests.
*   **[nws.sh](https://github.com/su-haris/simple-network-speedtest):** For providing the core engine for our global and regional speed tests.
