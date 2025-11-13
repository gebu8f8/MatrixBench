# 超到超無可超的程度
## CPU 拓撲結構分析
```
CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE
  0    0      0    0 0:0:0:0          yes
  1    0      1    1 1:1:1:1          yes
```

分析結果: 2 CPU (插槽), 2 物理核心, 2 線程 | 超線程(HT): 停用

**注意：偵測到核心分散於不同插槽，此架構可能因跨CPU通訊而影響效能。**

## CPU 誠信度測試
[參數: 2輪靜態分析, 優先級 80, 間隔 500µs]
```
[Round 1]
T0  Min: 6     Avg: 158   Max: 18225
T1  Min: 8     Avg: 154   Max: 11722
[Round 2]
T0  Min: 12    Avg: 112   Max: 12179
T1  Min: 8     Avg: 116   Max: 11482

[Stress Test - 16 Threads]
T: 0 (416460) P:80 I:500 C:  10000 Min:      7 Act:   54 Avg:   77 Max:   11232
T: 1 (416461) P:80 I:510 C:   9836 Min:      6 Act:  180 Avg:   80 Max:    9815
T: 2 (416462) P:80 I:520 C:   9652 Min:      6 Act:  140 Avg:   83 Max:   11000
T: 3 (416463) P:80 I:530 C:   9437 Min:      7 Act:   37 Avg:   85 Max:   11237
T: 4 (416464) P:80 I:540 C:   9275 Min:      6 Act:   17 Avg:   83 Max:   11581
T: 5 (416465) P:80 I:550 C:   9114 Min:      6 Act:  130 Avg:   84 Max:    9664
T: 6 (416466) P:80 I:560 C:   8983 Min:      6 Act:   22 Avg:   85 Max:   11359
T: 7 (416467) P:80 I:570 C:   8797 Min:      7 Act:   25 Avg:   88 Max:   10956
T: 8 (416468) P:80 I:580 C:   8637 Min:      6 Act:   30 Avg:   88 Max:    8926
T: 9 (416469) P:80 I:590 C:   8513 Min:      7 Act:   73 Avg:   87 Max:    9676
T:10 (416470) P:80 I:600 C:   8388 Min:      6 Act:   36 Avg:   87 Max:   11231
T:11 (416471) P:80 I:610 C:   8273 Min:      6 Act:   68 Avg:   84 Max:    9908
T:12 (416472) P:80 I:620 C:   8138 Min:      8 Act:  155 Avg:   87 Max:   10980
T:13 (416473) P:80 I:630 C:   7992 Min:      8 Act:  128 Avg:   89 Max:   11102
T:14 (416474) P:80 I:640 C:   7872 Min:      7 Act:   77 Avg:   88 Max:   10812
T:15 (416475) P:80 I:650 C:   7741 Min:      8 Act:   25 Avg:   91 Max:   11230

```

Steal Time (竊取時間) 峰值: 22.78%

最大內核延遲 (Max Latency): 18225 12179 µs

壓力測試峰值延遲 (Stress Peak): 11581 µs

---

**分析：檢測到顯著的 CPU Steal Time (>2.0%)。這表明 Hypervisor (底層母機) 無法穩定分配所承諾的 CPU 時間，性能會受到不可預測的嚴重影響。不適用於任何對穩定性有要求的生產環境。**
**壓力結論：性能反常。高壓下的延遲峰值反常地低於標準延遲，可能存在QoS限制或其他性能調度問題。**


# 真實機器

## CPU 拓撲結構分析
```
CPU NODE SOCKET CORE L1d:L1i:L2:L3 ONLINE
  0    0      0    0 0:0:0:0          yes
  1    0      0    1 1:1:1:0          yes
  2    0      0    2 2:2:2:0          yes
  3    0      0    3 3:3:3:0          yes
```

分析結果: 1 CPU (插槽), 4 物理核心, 4 線程 | 超線程(HT): 停用

## CPU 誠信度測試
[參數: 2輪靜態分析, 優先級 80, 間隔 500µs]
```
[Round 1]
T0  Min: 5     Avg: 24    Max: 2878 
T1  Min: 6     Avg: 25    Max: 2972 
T2  Min: 5     Avg: 24    Max: 2997 
T3  Min: 8     Avg: 22    Max: 134  
[Round 2]
T0  Min: 8     Avg: 22    Max: 157  
T1  Min: 8     Avg: 23    Max: 151  
T2  Min: 7     Avg: 23    Max: 539  
T3  Min: 8     Avg: 23    Max: 676  

[Stress Test - 32 Threads]
T: 0 (352714) P:80 I:500 C:  10000 Min:      4 Act:   17 Avg:   18 Max:    2976
T: 1 (352715) P:80 I:510 C:   9813 Min:      5 Act:   13 Avg:   17 Max:    3293
T: 2 (352716) P:80 I:520 C:   9633 Min:      6 Act:   15 Avg:   17 Max:    2140
T: 3 (352717) P:80 I:530 C:   9444 Min:      5 Act:    9 Avg:   16 Max:    2559
T: 4 (352718) P:80 I:540 C:   9251 Min:      5 Act:   33 Avg:   18 Max:    3077
T: 5 (352719) P:80 I:550 C:   9098 Min:      5 Act:   16 Avg:   17 Max:    2961
T: 6 (352720) P:80 I:560 C:   8949 Min:      5 Act:   16 Avg:   16 Max:    1972
T: 7 (352721) P:80 I:570 C:   8786 Min:      5 Act:    9 Avg:   17 Max:    2342
T: 8 (352722) P:80 I:580 C:   8617 Min:      5 Act:   15 Avg:   18 Max:    2685
T: 9 (352723) P:80 I:590 C:   8486 Min:      5 Act:   10 Avg:   17 Max:    3203
T:10 (352724) P:80 I:600 C:   8351 Min:      6 Act:   18 Avg:   16 Max:    1955
T:11 (352725) P:80 I:610 C:   8210 Min:      6 Act:    8 Avg:   17 Max:    2450
T:12 (352726) P:80 I:620 C:   8063 Min:      4 Act:   15 Avg:   18 Max:    2814
T:13 (352727) P:80 I:630 C:   7949 Min:      5 Act:   15 Avg:   17 Max:    2934
T:14 (352728) P:80 I:640 C:   7831 Min:      6 Act:   12 Avg:   17 Max:    2137
T:15 (352729) P:80 I:650 C:   7702 Min:      6 Act:    9 Avg:   18 Max:    2566
T:16 (352730) P:80 I:660 C:   7578 Min:      5 Act:   30 Avg:   19 Max:    2933
T:17 (352731) P:80 I:670 C:   7474 Min:      6 Act:    8 Avg:   18 Max:    2810
T:18 (352732) P:80 I:680 C:   7371 Min:      7 Act:   13 Avg:   18 Max:    2004
T:19 (352733) P:80 I:690 C:   7261 Min:      6 Act:   15 Avg:   17 Max:    2701
T:20 (352734) P:80 I:700 C:   7141 Min:      5 Act:   15 Avg:   19 Max:    2853
T:21 (352735) P:80 I:710 C:   7051 Min:      6 Act:   19 Avg:   18 Max:    2806
T:22 (352736) P:80 I:720 C:   6962 Min:      5 Act:   13 Avg:   18 Max:    2079
T:23 (352737) P:80 I:730 C:   6865 Min:      5 Act:   14 Avg:   17 Max:    2275
T:24 (352738) P:80 I:740 C:   6756 Min:      5 Act:   32 Avg:   19 Max:    2860
T:25 (352739) P:80 I:750 C:   6681 Min:      6 Act:   16 Avg:   18 Max:    2930
T:26 (352740) P:80 I:760 C:   6597 Min:      6 Act:   11 Avg:   17 Max:    1623
T:27 (352741) P:80 I:770 C:   6512 Min:      5 Act:    8 Avg:   17 Max:    2152
T:28 (352742) P:80 I:780 C:   6415 Min:      5 Act:   12 Avg:   19 Max:    3098
T:29 (352743) P:80 I:790 C:   6338 Min:      6 Act:   14 Avg:   19 Max:    3111
T:30 (352744) P:80 I:800 C:   6266 Min:      5 Act:   14 Avg:   17 Max:    1998
T:31 (352745) P:80 I:810 C:   6188 Min:      5 Act:    8 Avg:   17 Max:    2570

```

Steal Time (竊取時間) 峰值: 0.25%

最大內核延遲 (Max Latency): 2997 676 µs

壓力測試峰值延遲 (Stress Peak): 3293 µs

---

**分析：內核延遲存在輕微波動 (平均 1500µs - 4000µs)。這是典型且健康的共享虛擬化環境。CPU 資源與其他用戶共享，存在輕度鄰居干擾，適用於網站、部落格等通用型應用。**
**壓力結論：性能卓越。高壓下的延遲峰值與標準延遲相比，增幅在可控範圍內。**
