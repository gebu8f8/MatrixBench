# MatrixBench (MB) — 伺服器「誠信度」檢測專家
[简体中文](https://github.com/gebu8f8/MatrixBench/blob/main/README_cn.md) | [English](https://github.com/gebu8f8/MatrixBench/blob/main/README.md)

這不僅僅是又一個跑分腳本，它是一個**伺服器健康診斷儀**，旨在將模糊的「卡頓感」轉化為清晰、客觀的數據。

`MatrixBench` 的靈魂在於其獨創的 **CPU 誠信度測試**，通過分析 `Steal Time` 和 `內核延遲`，幫助你判斷 VPS 是否存在性能欺詐或嚴重超售。

## 核心亮點

*    **獨家 CPU 誠信度測試 (核心功能):** 深入分析 `Steal Time` 與壓力下的核心延遲，客觀評估伺服器的真實穩定性。
*    **全面硬體性能評測:** 涵蓋 CPU (sysbench & Geekbench 6)、記憶體和磁碟 I/O 的綜合基準測試。
*    **IP 與網路品質報告:** 一鍵生成 IP 質量分析、全球網路速度、延遲和回程路由的圖文報告。
*    **流媒體解鎖能力檢測:** 快速檢測伺服器解鎖各大主流流媒體平台的能力。
*    **自動化圖文報告:** 所有複雜的測試結果，最終都會為你生成易於分享和保存的圖片與結構化文本。

## 快速上手

執行以下指令即可開始全方位體檢。腳本會自動處理所需的依賴安裝。

```bash
bash <(curl -sL https://mb.gebu8f.com)
```
> **注意:** 首次運行或伺服器環境極簡時，腳本會自動安裝必要的工具（如 `curl`, `jq`, `wkhtmltoimage` 等），這可能需要一些時間。**不支持僅IPV6**需至少有ipv4

## 選項與參數

預設情況下，腳本會執行所有測試項目。你可以使用以下參數來運行特定的測試模組，節省時間。

| 參數 | 說明 |
|:------ | :----|
|`-l <lang>`| 設定腳本語言 (`cn` 為簡體中文, `us` 為英文 , 不選就是繁體中文)|
|`-hw`| 運行所有硬體相關測試 (基礎信息, 跑分, CPU拓撲, CPU 誠信度)|
|`-oversell` | **運行獨家的 CPU 誠信度與拓撲分析**|
|`-ip`| 運行 IP 質量檢測|
|`-nq`| 運行網路質量 (回程路由) 檢測|
|`-stream`| 運行流媒體解鎖測試|
|`-speedtest`| 運行全球 Speedtest 測速|
|`-ping`| 運行 Ping 延遲測試|
|`-stability`| 運行 aria2c 大流量下載穩定性測試|


### 使用範例

*   **只想快速檢查 CPU 是否超售？**
    ```bash
    bash mb.sh -oversell
    ```
*   **想做一個全面的硬體和網路評測，但不關心流媒體？**
    ```bash
    bash mb.sh -hw -ip -speedtest -ping
    ```
    *(你可以自由組合多個參數)*

## 📦 測試結果

所有測試完成後，生成的圖片報告 (`.png`) 和文本報告 (`.txt`) 都會保存在你主目錄下的 `result` 資料夾中 (`$HOME/result`)。

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
## 🚀 設為系統指令 (推薦)

為了方便使用，你可以執行以下指令，將 `MatrixBench` 安裝為一個全域的 `mb` 指令。這個指令會自動保持最新。

```bash
bash <(curl -sL https://mb.gebu8f.com) --install
```
## 詳細內容及文章
https://www.gebu8f.com/matrixbench/
## 🙏 致謝

本專案的順利開發，離不開以下優秀的開源專案和作者，在此表示誠摯的感謝。`MatrixBench` 是在他們的基礎之上，專注於提供更深層次的診斷分析。

*   **[yabs.sh](https://github.com/masonr/yet-another-bench-script):** 提供了業界標準的 Geekbench 和磁碟性能測試引擎。
*   **[spiritLH/ecs](https://github.com/spiritLH/ecs):** 俗稱「融合怪」，我們的系統信息展示、sysbench 邏輯功能深受其啟發。
*   **[xykt (@MoeClub)](https://github.com/MoeClub):** 其創作的 [IP.Check.Place](https://ip.check.place/) (`IPQuality`) 與 [Net.Check.Place](https://net.check.place/) (`NetQuality`) 腳本，為本專案的 IP 和網路質量分析提供了強大的核心支持。
* **[lmc999/RegionRestrictionCheck](https://github.com/lmc999/RegionRestrictionCheck):** 為我們的流媒體檢測提供了強大的核心支持。
