# MatrixBench (MB) — 伺服器「诚信度」检测专家
[繁體中文](https://github.com/gebu8f8/MatrixBench/blob/main/README_zh.md) | [English](https://github.com/gebu8f8/MatrixBench/blob/main/README.md)

这不仅仅是又一个跑分脚本，它是一个**伺服器健康诊断仪**，旨在将模糊的「卡顿感」转化为清晰、客观的数据。

`MatrixBench` 的灵魂在于其独创的 **CPU 诚信度测试**，通过分析 `Steal Time` 和 `内核延迟`，帮助你判断 VPS 是否存在性能欺诈或严重超售。

## 核心亮点

*    **独家 CPU 诚信度测试 (核心功能):** 深入分析 `Steal Time` 与压力下的核心延迟，客观评估伺服器的真实稳定性。
*    **全面硬体性能评测:** 涵盖 CPU (sysbench & Geekbench 6)、记忆体和磁碟 I/O 的综合基准测试。
*    **IP 与网络品质报告:** 一键生成 IP 质量分析、全球网络速度、延迟和回程路由的图文报告。
*    **流媒体解锁能力检测:** 快速检测伺服器解锁各大主流流媒体平台的能力。
*    **自动化图文报告:** 所有复杂的测试结果，最终都会为你生成易于分享和保存的图片与结构化文本。

## 快速上手

执行以下指令即可开始全方位体检。脚本会自动处理所需的依赖安装。

```bash
bash <(curl -sL https://mb.gebu8f.com) -l cn
```
> **注意:** 首次运行或伺服器环境极简时，脚本会自动安装必要的工具（如 `curl`, `jq`, `wkhtmltoimage` 等），这可能需要一些时间。 **不支持仅IPV6**需至少有ipv4

## 选项与参数

预设情况下，脚本会执行所有测试项目。你可以使用以下参数来运行特定的测试模组，节省时间。

| 参数 | 说明 |
| :--- | :--- |
| `-l <lang>`| 设定脚本语言 (`cn` 为简体中文, `us` 为英文 , 不选就是繁体中文)|
| `-hw`| 运行所有硬体相关测试 (基础信息, 跑分, CPU拓扑, CPU 诚信度)|
| `-oversell`| **运行独家的 CPU 诚信度与拓扑分析**|
| `-ip`| 运行 IP 质量检测|
| `-nq`| 运行网络质量 (回程路由) 检测|
| `-nr`| 运行中国三网络由测试|
| `-stream`| 运行流媒体解锁测试|
| `-speedtest`| 运行全球 Speedtest 测速|
| `-ping`| 运行 Ping 延迟测试|
| `-stability`| 运行 aria2c 大流量下载稳定性测试|
### 使用范例

*   **只想快速检查 CPU 是否超售？ **
```bash
bash mb.sh -oversell
```
*   **想做一个全面的硬体和网络评测，但不关心流媒体？ **
```bash
bash mb.sh -hw -ip -nq -speedtest -ping
```
*(你可以自由组合多个参数)*

## 📦 测试结果

所有测试完成后，生成的图片报告 (`.png`) 和文本报告 (`.txt`) 都会保存在你主目录下的 `result` 资料夹中 (`$HOME/result`)。
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
## 🚀 设为系统指令 (推荐)

为了方便使用，你可以执行以下指令，将 `MatrixBench` 安装为一个全域的 `mb` 指令。这个指令会自动保持最新。

```bash
bash <(curl -sL https://mb.gebu8f.com) --install
```
## 详细内容及文章
https://www.gebu8f.com/matrixbench/
## 🙏 致谢

本专案的顺利开发，离不开以下优秀的开源专案和作者，在此表示诚挚的感谢。 `MatrixBench` 是在他们的基础之上，专注于提供更深层次的诊断分析。

*   **[yabs.sh](https://github.com/masonr/yet-another-bench-script):** 提供了业界标准的 Geekbench 和磁碟性能测试引擎。
*   **[oneclickvirt/ecs](https://github.com/oneclickvirt/ecs):** 俗称「融合怪」，我们的系统信息展示、sysbench 逻辑功能深受其启发。
*   **[xykt](https://github.com/xykt):** 创作的 `IPQuality` 与 `NetQuality` 脚本，为本专案的 IP 和网络质量以及路由追踪分析提供了强大的核心支持。
*   **[lmc999/RegionRestrictionCheck](https://github.com/lmc999/RegionRestrictionCheck):** 为我们的流媒体检测提供了强大的核心支持。
*   **[nws.sh](https://github.com/su-haris/simple-network-speedtest):** 为我们的全球及区域速度测试，提供了核心支持。
