#!/bin/bash
# 檢查是否以root權限運行
if [ "$(id -u)" -ne 0 ]; then
  echo "此腳本需要 root 權限才能執行（This script requires root privileges to run）" 
  if command -v sudo >/dev/null 2>&1; then
    exec sudo "$0" "$@"
  else
    install_sudo_cmd=""
    if command -v apt >/dev/null 2>&1; then
      install_sudo_cmd="apt-get update && apt-get install -y sudo"
    elif command -v yum >/dev/null 2>&1; then
      install_sudo_cmd="yum install -y sudo"
    elif command -v apk >/dev/null 2>&1; then
      install_sudo_cmd="apk add sudo"
    else
      echo "No sudo command"
      sleep 1
      exit 1
    fi
    su -c "$install_sudo_cmd"
    if [ $? -eq 0 ] && command -v sudo >/dev/null 2>&1; then
      echo "sudo指令已經安裝成功，請等下輸入您的密碼（The sudo command has been installed successfully, please enter your password）"
      exec sudo "$0" "$@"
    fi
  fi
fi
lang=internationality
run_all=true
# 顏色定義
RED="\033[1;31m"    # ❌ 錯誤用紅色
GREEN="\033[1;32m"   # ✅ 成功用綠色
YELLOW='\033[1;33m'  # ⚠️ 警告用黃色
CYAN="\033[1;36m"    # ℹ️ 一般提示用青色
RESET='\033[0m'      # 清除顏色

version="v2025.10.26"

lang(){
  # 語言設定函式 - 目前使用命令行參數控制
  # 可在此處添加互動式語言
  # 繁體中文
  if [ "$lang" == "internationality" ]; then
    check_system_1="不支援 CentOS 7 或 CentOS 8，請升級至 9 系列 (Rocky/Alma/CentOS Stream)"
    compress_png_1="錯誤：檔案不存在於"
    compress_png_2="錯誤：圖片壓縮過程中發生未知錯誤。"
    ecs_simple_static_1="讀取系統資訊..."
    ecs_simple_static_2="系統資訊"
    hardware_benchmarks_1="錯誤：找不到執行檔"
    hardware_benchmarks_2="正在執行 goecs 基礎硬體測試 (這可能需要1-2分鐘)..."
    hardware_benchmarks_3="正在執行 yabs.sh Geekbench 6 測試 (這可能需要5-15分鐘)..."
    cpu_test_1="CPU 拓撲結構分析開始"
    cpu_test_2="lscpu -e 原始輸出"
    ip_quality_1="開始執行IP質量檢測（需5-15分鐘）"
    ip_quality_2="IP 品質體檢報告"
    net_quality_1="開始執行網路質量檢測（需10-20分鐘）"
    net_quality_2="網路品質體檢報告"
    streaming_unlock_1="開始執行流媒體解鎖測試"
    streaming_unlock_2="流媒體解鎖測試報告"
    regional_speedtest_1="警告：無法取得 IP 地理資訊，將跳過區域測速。"
    regional_speedtest_2="資訊：未找到明確的洲別對應，將跳過區域測速。"
    speedtest_global_1="正在執行全球網路測速，這可能需要 15-30 分鐘，請耐心等待..."
    speedtest_global_2="警告：偵測到速率限制，將跳過區域測速。"
  elif [ "$lang" == "cn" ]; then
    check_system_1="不支援 CentOS 7 或 CentOS 8，请升级至 9 系列 (Rocky/Alma/CentOS Stream)"
    compress_png_1="错误：档案不存在于"
    compress_png_2="错误：图片压缩过程中发生未知错误。"
    ecs_simple_static_1="读取系统资讯..."
    ecs_simple_static_2="系统资讯"
    hardware_benchmarks_1="错误：找不到执行档"
    hardware_benchmarks_2="正在执行 goecs 基础硬体测试 (这可能需要1-2分钟)..."
    hardware_benchmarks_3="正在执行 yabs.sh Geekbench 6 测试 (这可能需要5-15分钟)..."
    cpu_test_1="CPU 拓扑结构分析开始"
    cpu_test_2="lscpu -e 原始输出"
    ip_quality_1="开始执行IP质量检测（需5-15分钟）"
    ip_quality_2="IP 品质体检报告"
    streaming_unlock_1="开始执行流媒体解锁测试"
    streaming_unlock_2="流媒体解锁测试报告"
    regional_speedtest_1="警告：无法取得 IP 地理资讯，将跳过区域测速。"
    regional_speedtest_2="资讯：未找到明确的洲别对应，将跳过区域测速。"
    speedtest_global_1="正在执行全球网路测速，这可能需要 15-30 分钟，请耐心等待..."
    speedtest_global_2="警告：侦测到速率限制，将跳过区域测速。"
  elif [ "$lang" == "us" ]; then
    check_system_1="CentOS 7 or CentOS 8 are not supported. Please upgrade to 9 series (Rocky/Alma/CentOS Stream)"
    compress_png_1="Error: The file does not exist in"
    compress_png_2="Error: An unknown error occurred during image compression."
    cpu_test_1="CPU topology analysis begins"
    cpu_test_2="lscpu -e raw output"
    hardware_benchmarks_1="Error: Execution file not found"
    hardware_benchmarks_2="Running the goecs basic hardware test (this may take 1-2 minutes)..."
    hardware_benchmarks_3="Running the yabs.sh Geekbench 6 test (this may take 5-15 minutes)..."
    cpu_test_1="CPU topology analysis started"
    cpu_test_2="lscpu -e raw output"
    ip_quality_1="Start IP quality check (takes 5-15 minutes)"
    ip_quality_2="IP quality check report"
    streaming_unlock_1="Start streaming unlock test"
    streaming_unlock_2="Streaming unlock test report"
    regional_speedtest_1="Warning: Unable to obtain IP geolocation information, skipping regional speed test."
    regional_speedtest_2="Info: No clear continent mapping found, skipping regional speed test."
    speedtest_global_1="Running a global network speed test. This may take 15-30 minutes, please be patient..."
    speedtest_global_2="Warning: Rate limiting detected, skipping regional speed test."
  fi
}

check_system(){
  if command -v apt >/dev/null 2>&1; then
    system=1
  elif command -v yum >/dev/null 2>&1; then
    system=2
    if grep -q -Ei "release 7|release 8" /etc/redhat-release; then
      echo -e "${RED}$check_system_1${RESET}"
      exit 1
    fi
   else
    echo -e "${RED}不支援的系統。(Unsupported system.)${RESET}" >&2
    exit 1
  fi
}
install_wkhtmltox() {
  local ARCH=$(uname -m)
  local TEMP_WORKDIR="/tmp/wkhtmltox_install"
  mkdir -p "$TEMP_WORKDIR"

  # --- 判斷發行版類型 ---
  if [ -f /etc/fedora-release ]; then
    yum install -y "https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox-0.12.6.1-3.fedora37.x86_64.rpm"
  elif [ -f /etc/redhat-release ]; then
    local RHEL_VER=$(grep -oE '[0-9]+' /etc/redhat-release | head -n1)
    if [ "$RHEL_VER" -ge 9 ]; then
      RHEL_VER=9
    else
      RHEL_VER=8
    fi
    # 下載 RPM 安裝包
    local RPM_URL="https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6.1-3/wkhtmltox-0.12.6.1-3.almalinux$.$ARCH.rpm"
        local RPM_PATH="$TEMP_WORKDIR/wkhtmltox.rpm"

    if yum install -y $RPM_URL; then
      echo -e "${GREEN}wkhtmltox installed successfully on CentOS/AlmaLinux.${RESET}"
    else
      echo -e "${RED}Failed to download wkhtmltox RPM package.${RESET}"
      exit 1
    fi
  else
    if ! dpkg -l | grep -q "libssl1.1"; then
      local LIBSSL_URL=""
      if [ "$ARCH" = "x86_64" ]; then
        LIBSSL_URL="https://ftp.us.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_amd64.deb"
      elif [ "$ARCH" = "aarch64" ]; then
        LIBSSL_URL="https://ftp.us.debian.org/debian/pool/main/o/openssl/libssl1.1_1.1.1w-0+deb11u1_arm64.deb"
      fi
      if [ -n "$LIBSSL_URL" ]; then
        local LIBSSL_PATH="$TEMP_WORKDIR/libssl1.1.deb"
        curl -sL -o "$LIBSSL_PATH" "$LIBSSL_URL" && dpkg -i "$LIBSSL_PATH"
      fi
    fi
    # 安裝 wkhtmltox 主體
    local WK_VER="0.12.6-1"
    local DEB_URL=""
    if [ "$ARCH" = "x86_64" ]; then
      DEB_URL="https://github.com/wkhtmltopdf/packaging/releases/download/${WK_VER}/wkhtmltox_${WK_VER}.buster_amd64.deb"
    elif [ "$ARCH" = "aarch64" ]; then
      DEB_URL="https://github.com/wkhtmltopdf/packaging/releases/download/${WK_VER}/wkhtmltox_${WK_VER}.buster_arm64.deb"
    fi

    if [ -n "$DEB_URL" ]; then
      local DEB_PATH="$TEMP_WORKDIR/wkhtmltox.deb"
      if curl -sL -o "$DEB_PATH" "$DEB_URL"; then
        dpkg -i "$DEB_PATH" || apt -f install -y
        echo -e "${GREEN}wkhtmltox installed successfully on Debian/Ubuntu.${RESET}"
      else
        echo -e "${RED}Failed to download wkhtmltox DEB package.${RESET}"
                return 1
      fi
    fi
  fi
  return 0
}


check_app(){
  # 根據系統選擇 script 對應套件
  if [ "$system" -eq 1 ]; then
    pkg_script="bsdutils"
  else
    pkg_script="util-linux"
  fi

  # 定義指令與套件對應關係
  declare -A pkg_map=(
    ["stress-ng"]="stress-ng"
    ["sar"]="sysstat"
    ["curl"]="curl"
    ["jq"]="jq"
    ["unzip"]="unzip"
    ["fc-list"]="fontconfig"
    ["script"]="$pkg_script"
    ["aha"]="aha"
    ["pngquant"]="pngquant"
    ["bc"]="bc"
    ["cyclictest"]="rt-tests"
    ["sysbench"]="sysbench"
  )
  if [ $system == 2 ]; then
    if ! yum repolist enabled | grep -q "epel"; then
      yum install -y epel-release
    fi
  fi

  # 逐一檢查並安裝
  for cmd in "${!pkg_map[@]}"; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      pkg="${pkg_map[$cmd]}"
      case "$system" in
      1) apt update -qq && apt install -y "$pkg" ;;
      2) yum install -y "$pkg" ;;
      esac
    fi
  done
  
  # --- Emoji 字體安裝 ---
  if ! fc-list | grep -qi "NotoColorEmoji"; then
    echo -e "${CYAN}Installing Noto Color Emoji font...${RESET}"
    case $system in
      1) apt install -y fonts-noto-color-emoji ;;
      2)
        yum install -y epel-release
        yum install -y google-noto-emoji-color-fonts
        ;;
    esac
  fi
  if ! fc-list | grep -qi "wqy-zenhei"; then
    case $system in
      1) apt-get install -y fonts-wqy-zenhei ;;
      2) yum install -y wqy-zenhei-fonts ;; # 在 CentOS/RHEL 上的包名不同
      3) apk add --no-cache font-wqy-zenhei ;;
    esac
  fi
  if ! command -v wkhtmltoimage >/dev/null 2>&1; then
    case $system in
    1)
      apt install -y wkhtmltopdf
      ;;
    2)
      yum install -y wkhtmltopdf
      ;;
    esac
    if ! command -v "wkhtmltoimage" &> /dev/null; then
      install_wkhtmltox_manual
    fi
  fi
}
compress_png() {
  local image_path="$1"

  if [[ ! -f "$image_path" ]]; then
    echo -e "${RED}$compress_png_1'${image_path}'${RESET}" >&2
    return 1
  fi


  # 步驟 4：執行壓縮命令
  pngquant --quality 70-100 --ext .png --force --skip-if-larger "$image_path" 1>/dev/null

  if [[ $? -eq 0 ]]; then
    sync
  else
    if ! [[ $? -eq 99 ]]; then
      echo -e "${RED}${RESET}" >&2
      return 1
    fi
  fi
}

ecs_download() {
  # 使用 curl 呼叫 API，並透過 jq 解析 JSON 以取得 tag_name
  if [ -f $TEMP_WORKDIR/goces ]; then
    return
  fi
  local LATEST_TAG
  LATEST_TAG=$(curl -s "https://api.github.com/repos/oneclickvirt/ecs/releases/latest" | jq -r '.tag_name')

  # 3. 偵測系統指令集 (x86_64 -> amd64, aarch64 -> arm64)
  local SYS_ARCH
  SYS_ARCH=$(uname -m)
  local DL_ARCH # 用於下載的架構名稱

  case "$SYS_ARCH" in
    "x86_64")
      DL_ARCH="amd64"
      ;;
    "aarch64")
      DL_ARCH="arm64"
      ;;
    *)
      if [ "$lang" == "cn" ]; then
        echo -e "${RED}错误：不支援的系统架构 '$SYS_ARCH'。仅支援 x86_64 (amd64) 和 aarch64 (arm64)。${RESET}"
      elif [ "$lang" == "us" ]; then
        echo -e "${RED}ERROR: Unsupported system architecture '$SYS_ARCH'. Only x86_64 (amd64) and aarch64 (arm64) are supported.${RESET}"
      else
        echo -e "${RED}錯誤：不支援的系統架構 '$SYS_ARCH'。僅支援 x86_64 (amd64) 和 aarch64 (arm64)。${RESET}"
      fi
      sleep 1
      exit 1
      ;;
  esac

  # 4. 組合下載 URL 並選擇下載
  local FILENAME="goecs_linux_${DL_ARCH}.zip"
  local DOWNLOAD_URL="https://github.com/oneclickvirt/ecs/releases/download/${LATEST_TAG}/${FILENAME}"
  local ZIPPED_FILE_PATH="${TEMP_WORKDIR}/${FILENAME}"

  # 執行下載
  curl -sL -o "$ZIPPED_FILE_PATH" "$DOWNLOAD_URL" >/dev/null

  # 5. 解壓縮檔案
  # 使用 -o 選項會覆蓋任何已存在的同名檔案，-d 指定解壓縮的目的地
  unzip -o "$ZIPPED_FILE_PATH" -d "$TEMP_WORKDIR"
  # 6. 刪除壓縮檔
  rm "$ZIPPED_FILE_PATH"
}
ecs_simple_static() (
  local EXECUTABLE_PATH="$TEMP_WORKDIR/goecs"
  local RESULT_DIR="$HOME/result"
  local TEMP_HTML="$TEMP_WORKDIR/temp.html"
  local TEMP_OUTPUT="$TEMP_WORKDIR/temp_output.txt"
  local FINAL_IMAGE_FILE="${RESULT_DIR}/base.png"

  #--- 語系設定 -------------------------------------------------
  case "$lang" in
    cn)
      local t_reading="读取系统资讯..."
      local t_complete="读取系统资讯完成"
      local t_title="系统资讯"
      local lang_param="zh"
      local title_keyword="系统基础信息"
      ;;
    us)
      local t_reading="Reading system information..."
      local t_complete="System information reading completed"
      local t_title="System Information"
      local lang_param="en"
      local title_keyword="System-Basic-Information"
      ;;
    *)
      local t_reading="讀取系統資訊..."
      local t_complete="讀取系統資訊完成"
      local t_title="系統資訊"
      local lang_param="zh"
      local title_keyword="系统基础信息"
      ;;
  esac

  echo -e "${CYAN}${t_reading}${RESET}"
  mkdir -p "$RESULT_DIR"
  cd "$TEMP_WORKDIR" || exit 1
  
  script -qfc "$EXECUTABLE_PATH -l $lang_param -menu=false -log=false \
    -basic=true -cpu=false -memory=false -disk=false \
    -comm=false -email=false -nt3=false -security=false \
    -speed=false -upload=false -ut=false -backtrace=false" \
    /dev/null 2>/dev/null | tee "$TEMP_OUTPUT"

  echo -e "${GREEN}${t_complete}${RESET}"

  #--- 2. 只保留「系統資訊」區塊 ------------------------------------
  local extracted_block=$(awk -v kw="$title_keyword" '
    # 規則1: 只要找到包含關鍵字的行，就打開 "found" 開關
    $0 ~ kw { found=1 }
    
    # 規則2: 只要 "found" 開關是打開的，就執行以下操作
    found {
        # 動作1: 打印當前行
        print
        
        # 動作2: 檢查是否滿足 "終結條件"
        # 條件是：以 "---" 開頭，並且不包含我們的關鍵字
        if ($0 ~ /^---/ && $0 !~ kw) {
            exit # 滿足條件，打印完後立刻退出
        }
    }
  ' "$TEMP_OUTPUT")
  
  aha --title "$t_title" --stylesheet <<< "$extracted_block" > "$TEMP_HTML"
  sed -i '/<\/style>/i \
    body { background-color: #0c0c0c; color: #cccccc; font-family: "Noto Color Emoji", "Segoe UI Emoji", "Apple Color Emoji", "Courier New", monospace; padding: 20px; } \
    pre { white-space: pre-wrap; word-wrap: break-word; }' "$TEMP_HTML"
  wkhtmltoimage \
    --width 800 \
    --height 0 \
    --quality 100 \
    --encoding utf-8 \
    --enable-local-file-access \
    "$TEMP_HTML" \
    "$FINAL_IMAGE_FILE" >/dev/null 2>&1
    compress_png "$FINAL_IMAGE_FILE"
)

hardware_benchmarks() (
  # --- 設定 ---
  local ECS_DIR="$TEMP_WORKDIR"
  local EXECUTABLE_PATH="${ECS_DIR}/goecs"
  local RESULT_DIR="$HOME/result"
  local RESULT_FILE="${RESULT_DIR}/hardware.txt"
  local cpu_count
  cpu_count=$(nproc)


  # --- 步驟 1: 檢查 goecs 執行檔 ---
  if [[ ! -f "$EXECUTABLE_PATH" ]]; then
    echo -e "${RED}$hardware_benchmarks_1'${EXECUTABLE_PATH}'。${RESET}"
    exit 1
  fi
  if [[ ! -x "$EXECUTABLE_PATH" ]]; then
    chmod +x "$EXECUTABLE_PATH"
  fi

  # --- 步驟 2: 執行 goecs 並捕獲輸出 ---
  echo "$hardware_benchmarks_2"
  cd $TEMP_WORKDIR
  local goecs_output=$("$EXECUTABLE_PATH" -l en -log=false -menu=false -cpu=true -memory=true -disk=true -basic=false -comm=false -email=false -nt3=false -security=false -speed=false -upload=false -ut=false -backtrace=false -memorym sysbench)
  echo "$goecs_output"

  # --- 步驟 3: 執行 yabs.sh 並捕獲輸出 ---
  echo "$hardware_benchmarks_3"
  local yabs_output=$(curl -sL https://yabs.sh | bash -s -- -fi6)
  echo "$yabs_output"
  
  # --- 步驟 4: 解析所有捕獲的輸出 ---

  # CPU sysbench
  local sys_single_score=$(echo "$goecs_output" | grep '1 Thread(s) Test:' | awk '{print $NF}')
  local sys_multi_score=$(echo "$goecs_output" | grep 'Thread(s) Test:' | tail -n 1 | awk '{print $NF}')

  # Geekbench 6 (先切割區塊再解析，更穩定)
  local gb6_section=$(echo "$yabs_output" | awk '/Geekbench 6 Benchmark Test:/, /YABS completed in/ {if ($0 !~ /YABS completed in/) print}')
  local gb6_single_score=$(echo "$gb6_section" | grep 'Single Core' | awk '{print $4}')
  local gb6_multi_score=$(echo "$gb6_section" | grep 'Multi Core' | awk '{print $4}')

  # 記憶體解析 (採用您優化的版本)
  local mem_write_speed=$(echo "$goecs_output" \
    | grep -E 'Single[[:space:]]+Seq[[:space:]]+Write[[:space:]]+Speed' \
    | sed -E 's/.*[:：][[:space:]　]+//')
  local mem_read_speed=$(echo "$goecs_output" \
    | grep -E 'Single[[:space:]]+Seq[[:space:]]+Read[[:space:]]+Speed' \
    | sed -E 's/.*[:：][[:space:]　]+//')

  # 硬碟解析輔助函式
  parse_disk_speed() {
    echo "$1" | awk -v block="$2" -v field_num="$3" '
      $2 == block {
        val_col = field_num
        unit_col = field_num + 1
        sub(/\(.*/, "", $unit_col)
        print $val_col, $unit_col
      }
    '
  }
  
  # 補全所有硬碟數據的解析
  local disk_r_4k=$(parse_disk_speed "$goecs_output" "4k" 3)
  local disk_w_4k=$(parse_disk_speed "$goecs_output" "4k" 5)
  local disk_t_4k=$(parse_disk_speed "$goecs_output" "4k" 7)
  local disk_r_64k=$(parse_disk_speed "$goecs_output" "64k" 3)
  local disk_w_64k=$(parse_disk_speed "$goecs_output" "64k" 5)
  local disk_t_64k=$(parse_disk_speed "$goecs_output" "64k" 7)
  local disk_r_512k=$(parse_disk_speed "$goecs_output" "512k" 3)
  local disk_w_512k=$(parse_disk_speed "$goecs_output" "512k" 5)
  local disk_t_512k=$(parse_disk_speed "$goecs_output" "512k" 7)
  local disk_r_1m=$(parse_disk_speed "$goecs_output" "1m" 3)
  local disk_w_1m=$(parse_disk_speed "$goecs_output" "1m" 5)
  local disk_t_1m=$(parse_disk_speed "$goecs_output" "1m" 7)


  # --- 步驟 5: 創建目錄並寫入格式化後的結果 ---
  mkdir -p "$RESULT_DIR"

  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_cpu_sys="## CPU测试（sysbench）"
      local t_single="单核"
      local t_multi="多核"
      local t_cpu_gb6="## CPU测试（GeekBench 6）"
      local t_memory="## 内存测试"
      local t_read="读取"
      local t_write="写入"
      local t_disk="## 硬盘"
      local t_combined="总合"
      ;;
    us)
      local t_cpu_sys="CPU Test (sysbench)"
      local t_single="Single Core"
      local t_multi="Multi Core"
      local t_cpu_gb6="## CPU Test (GeekBench 6)"
      local t_memory="## Memory Test"
      local t_read="Read"
      local t_write="Write"
      local t_disk="## Disk"
      local t_combined="Total"
      ;;
    *)
      local t_cpu_sys="## CPU測試（sysbench）"
      local t_single="單核"
      local t_multi="多核"
      local t_cpu_gb6="## CPU測試（GeekBench 6）"
      local t_memory="## 記憶體測試"
      local t_read="讀取"
      local t_write="寫入"
      local t_disk="## 硬碟"
      local t_combined="總合"
      ;;
  esac

  {
    echo "$t_cpu_sys"
    if [ "$cpu_count" -eq 1 ]; then
      echo "${t_single}：${sys_single_score:-N/A}"
    else
      echo "${t_single}：${sys_single_score:-N/A}"
      echo "${t_multi}：${sys_multi_score:-N/A}"
    fi
    echo ""
    echo "$t_cpu_gb6"
    echo "${t_single}：${gb6_single_score:-N/A}"
    echo "${t_multi}：${gb6_multi_score:-N/A}"
    echo ""
    echo "$t_memory"
    echo "${t_read}：${mem_read_speed:-N/A}"
    echo "${t_write}：${mem_write_speed:-N/A}"
    echo ""
    echo "$t_disk"
    echo "| | 4k | 64k | 512k | 1m |"
    echo "|:---|:---|:---|:---|:---|"
    echo "| $t_read | ${disk_r_4k:-N/A} | ${disk_r_64k:-N/A} | ${disk_r_512k:-N/A} | ${disk_r_1m:-N/A} |"
    echo "| $t_write | ${disk_w_4k:-N/A} | ${disk_w_64k:-N/A} | ${disk_w_512k:-N/A} | ${disk_w_1m:-N/A} |"
    echo "| $t_combined | ${disk_t_4k:-N/A} | ${disk_t_64k:-N/A} | ${disk_t_512k:-N/A} | ${disk_t_1m:-N/A} |"
  } > "$RESULT_FILE"
)
cpu_test() {
  local report="$HOME/result/hardware.txt"

  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_start="CPU 拓扑结构分析开始"
      local t_output="lscpu -e 原始输出"
      local t_error=">> 错误：无法执行 'lscpu -e' 或输出为空。"
      local t_disabled="停用"
      local t_enabled="启用"
      local t_result="分析结果"
      local t_socket="CPU (插槽)"
      local t_physical="物理核心"
      local t_thread="线程"
      local t_ht="超线程(HT)"
      local t_warning="注意：侦测到核心分散于不同插槽，此架构可能因跨CPU通信而影响效能。"
      local t_title="## CPU 拓扑结构分析"
      ;;
    us)
      local t_start="CPU Topology Analysis Started"
      local t_output="lscpu -e Raw Output"
      local t_error=">> Error: Unable to execute 'lscpu -e' or output is empty."
      local t_disabled="Disabled"
      local t_enabled="Enabled"
      local t_result="Analysis Result"
      local t_socket="CPU (Socket)"
      local t_physical="Physical Core"
      local t_thread="Thread"
      local t_ht="Hyper-Threading (HT)"
      local t_warning="Warning: Cores detected across different sockets. This architecture may impact performance due to cross-CPU communication."
      local t_title="## CPU Topology Analysis"
      ;;
    *)
      local t_start="CPU 拓撲結構分析開始"
      local t_output="lscpu -e 原始輸出"
      local t_error=">> 錯誤：無法執行 'lscpu -e' 或輸出為空。"
      local t_disabled="停用"
      local t_enabled="啟用"
      local t_result="分析結果"
      local t_socket="CPU (插槽)"
      local t_physical="物理核心"
      local t_thread="線程"
      local t_ht="超線程(HT)"
      local t_warning="注意：偵測到核心分散於不同插槽，此架構可能因跨CPU通訊而影響效能。"
      local t_title="## CPU 拓撲結構分析"
      ;;
  esac

  echo "$t_start"

  # 執行 lscpu -e 並捕獲其輸出
  local lscpu_output
  lscpu_output=$(lscpu -e 2>/dev/null)

  if [ -z "$lscpu_output" ]; then
    echo "$t_error"
    return 1
  fi

  # 1. 在終端顯示原始輸出
  echo "--- $t_output ---"
  echo "$lscpu_output"
  echo "--------------------------"

  # 2. 進行分析
  local data_lines=$(echo "$lscpu_output" | tail -n +2)
  local logical_cores=$(echo "$data_lines" | grep -c .)
  local sockets=$(echo "$data_lines" | awk '{print $3}' | sort -u | wc -l)
  local physical_cores=$(echo "$data_lines" | awk '{print $3, $4}' | sort -u | wc -l)

  local ht_status="$t_disabled"
  if [ "$logical_cores" -gt "$physical_cores" ]; then
    ht_status="$t_enabled"
  fi
  
  # 3. 產生帶有智能判斷的分析摘要
  local analysis_summary
  if [ "$sockets" -gt 1 ] && [ "$physical_cores" -eq "$sockets" ]; then
    # 【關鍵】在這裡，我們使用 printf 的 -v 選項來安全地將多行文本賦值給變數，避免 \n 問題的根源
    printf -v analysis_summary "%s: %d %s, %d %s | %s: %s\n%s" \
      "$t_result" "$sockets" "$t_socket" "$physical_cores" "$t_physical" \
      "$t_ht" "$ht_status" "$t_warning"
  else
    analysis_summary="${t_result}: ${sockets} ${t_socket}, ${physical_cores} ${t_physical}, ${logical_cores} ${t_thread} | ${t_ht}: ${ht_status}"
  fi

  # 4. 將分析結果顯示在終端
  echo -e "$analysis_summary"

  # 5. 將所有內容附加到報告文件
  {
    echo "" 
    echo "$t_title"
    echo '```'
    echo "$lscpu_output"
    echo '```'
    echo ""
    echo -e "$analysis_summary"
  } >> "$report"
}
cpu_oversell_test() {
  local report="$HOME/result/hardware.txt"
  mkdir -p "$(dirname "$report")"

  # --- 多語言文本定義 (整合版) ---
  case "$lang" in
  cn)
    local t_warm="系统非空闲 (当前CPU总使用率: %.0f%%)，测试结果可能不准。"
    local t_title="## CPU 诚信度与压力测试"
    local t_start="${CYAN}开始执行 CPU 诚信度与压力综合测试...${RESET}"
    local t_params="[参数: 2轮静态分析 + 1轮压力分析]"
    local t_test_run="正在进行第 %d/2 次静态分析 (此过程约需 15 秒)..."
    local t_post_rest="${CYAN}第一次测试完成，30 秒冷却中...${RESET}"
    local t_stress_start="${CYAN}静态分析完成，开始执行压力测试...${RESET}"
    local t_analysis="--- 最终分析结论 ---"
    local t_st_report="Steal Time (窃取时间) 峰值: %.2f%%"
    local t_lat_report="标准测试最大延迟 (Std Latency): %s µs"
    local t_stress_report="压力测试峰值延迟 (Stress Peak): %d µs"
    local t_conclusion_st_fail="分析：检测到显著的 CPU Steal Time (>2.0%)。这表明 Hypervisor (底层母机) 无法稳定分配所承诺的 CPU 时间，性能会受到不可预测的严重影响。不适用于任何对稳定性有要求的生产环境。"
    local t_conclusion_lat_exc="分析：内核延迟极低且稳定 (平均 < 1500µs)。性能表现极其稳定，接近实体机水平，CPU 资源几乎无干扰。非常适用于延迟敏感型应用 (如游戏服务器、即时通讯)。"
    local t_conclusion_lat_good="分析：内核延迟存在轻微波动 (平均 1500µs - 4000µs)。这是典型且健康的共享虚拟化环境。CPU 资源与其他用户共享，存在轻度邻居干扰，适用于网站、博客等通用型应用。"
    local t_conclusion_lat_bad="分析：内核延迟存在严重抖动 (平均 > 4000µs)。CPU 资源争抢严重，性能一致性差。在负载稍高时可能会出现明显卡顿。适用于离线任务或对性能稳定性要求极低的场景。"
    local t_stress_conclusion_low_impact="压力结论：性能卓越。高压下的延迟峰值与标准延迟相比，增幅在可控范围内。"
    local t_stress_conclusion_high_impact="压力结论：性能稳定。高压下的延迟峰值相比标准延迟有显著增加，但未失控。"
    local t_stress_conclusion_bottleneck="压力结论：性能瓶颈。高压下的延迟峰值相比标准延迟出现指数级增长，已达性能瓶頸。"
    local t_stress_params="[压力参数: %d个并发线程]"
    local t_stress_conclusion_abnormal="压力结论：性能反常。高压下的延迟峰值反常地低于标准延迟，可能存在QoS限制或其他性能调度问题。"
    ;;
  us)
    local t_warm="The system is not idle (current total CPU usage: %.0f%%), the test results may be inaccurate."
    local t_title="## CPU Honesty Test"
    local t_start="${CYAN}Starting CPU Honesty Test...${RESET}"
    local t_params="[Parameters: 2 rounds of static analysis, Prio 80, Interval 500µs]"
    local t_test_run="Running static analysis %d/2 (this takes about 15 seconds)..."
    local t_post_rest="${CYAN}First run complete, cooling down for 30 seconds...${RESET}"
    local t_analysis="--- Final Analysis Conclusion ---"
    local t_st_report="Peak Steal Time: %.2f%%"
    local t_lat_report="Max Kernel Latency: %s µs"
    local t_stress_report="Stress Peak: %d µs"
    local t_conclusion_st_fail="Analysis: Significant CPU Steal Time (>2.0%) was detected. This indicates the Hypervisor is failing to provide the guaranteed CPU time, leading to unpredictable and severe performance degradation. Not suitable for any production environment that requires stability."
    local t_conclusion_lat_exc="Analysis: Kernel latency is extremely low and stable (average < 1500µs). This indicates near-bare-metal performance with minimal CPU resource interference. Ideal for latency-sensitive applications like game servers or real-time communication."
    local t_conclusion_lat_good="Analysis: Minor fluctuations in kernel latency were observed (average 1500µs - 4000µs). This is typical of a healthy, shared virtualization environment. Suitable for general-purpose applications like websites and blogs."
    local t_conclusion_lat_bad="Analysis: Severe jitter in kernel latency was detected (average > 4000µs). This suggests significant CPU resource contention and poor performance consistency. Only suitable for offline tasks or scenarios with very low stability requirements."
    local t_stress_conclusion_low_impact=" Stress Conclusion: Excellent performance. The peak latency under high pressure increases within a manageable range compared to the standard latency."
    local t_stress_conclusion_high_impact="Stress Conclusion: Stable performance. The peak latency under high pressure increases significantly compared to the standard latency, but remains within control."

    local t_stress_conclusion_bottleneck="Stress Conclusion: Performance bottleneck. The peak latency under high pressure increases exponentially compared to the standard latency, reaching a performance bottleneck."
    local t_stress_params="[Stress Parameters: %d concurrent threads]"
    local t_stress_conclusion_abnormal="Stress Conclusion: Abnormal Performance. Peak latency under high load is abnormally lower than standard latency, suggesting potential QoS throttling or other performance scheduling issues."
    ;;
  *)
    local t_warm="系統非空閒 (當前CPU總使用率: %.0f%%)，測試結果可能不準。"
    local t_title="## CPU 誠信度測試"
    local t_start="${CYAN}開始執行 CPU 誠信度測試...${RESET}"
    local t_params="[參數: 2輪靜態分析, 優先級 80, 間隔 500µs]"
    local t_test_run="正在進行第 %d/2 次靜態分析 (此過程約需 15 秒)..."
    local t_post_rest="${CYAN}第一次測試完成，30 秒冷卻中...${RESET}"
    local t_analysis="--- 最終分析結論 ---"
    local t_st_report="Steal Time (竊取時間) 峰值: %.2f%%"
    local t_lat_report="最大內核延遲 (Max Latency): %s µs"
    local t_stress_report="壓力測試峰值延遲 (Stress Peak): %d µs"
    local t_conclusion_st_fail="分析：檢測到顯著的 CPU Steal Time (>2.0%)。這表明 Hypervisor (底層母機) 無法穩定分配所承諾的 CPU 時間，性能會受到不可預測的嚴重影響。不適用於任何對穩定性有要求的生產環境。"
    local t_conclusion_lat_exc="結論：分析：內核延遲極低且穩定 (平均 < 1500µs)。性能表現極其穩定，接近實體機水平，CPU 資源幾乎無干擾。非常適用於延遲敏感型應用 (如遊戲伺服器、即時通訊)。"
    local t_conclusion_lat_good="分析：內核延遲存在輕微波動 (平均 1500µs - 4000µs)。這是典型且健康的共享虛擬化環境。CPU 資源與其他用戶共享，存在輕度鄰居干擾，適用於網站、部落格等通用型應用。"
    local t_conclusion_lat_bad="分析：內核延遲存在嚴重抖動 (平均 > 4000µs)。CPU 資源爭搶嚴重，性能一致性差。在負載稍高時可能會出現明顯卡頓。適用於離線任務或對性能穩定性要求極低的場景。"
    local t_stress_conclusion_low_impact="壓力結論：性能卓越。高壓下的延遲峰值與標準延遲相比，增幅在可控範圍內。"
    local t_stress_conclusion_high_impact="壓力結論：性能穩定。高壓下的延遲峰值相比標準延遲有顯著增加，但未失控。"
    local t_stress_conclusion_bottleneck="壓力結論：性能瓶頸。高壓下的延遲峰值相比標準延遲出現指數級增長，已達性能瓶頸。"
    local t_stress_params="[壓力參數: %d個並發線程]"
    local t_stress_conclusion_abnormal="壓力結論：性能反常。高壓下的延遲峰值反常地低於標準延遲，可能存在QoS限制或其他性能調度問題。"
    ;;
  local esaccpu_idle=$(mpstat 1 1 | awk '/Average/ {print 100 - $12}')
  if (( $(echo "$cpu_idle > 10" | bc -l) )); then
    printf "${YELLOW}"
    printf "$t_warm" "$cpu_usage"
    printf "${RESET}\n"
  fi

  echo -e "\n$t_start"
  echo "$t_params"

  local peak_st_value=0.0
  local all_poetic_outputs=""
  local cpu_count=$(nproc)
  local -a max_latencies=()
  local test_rounds=2

  # --- 第一部分：標準靜態分析 ---
  for (( i=1; i<=test_rounds; i++ )); do
    printf "\n$t_test_run\n" "$i"

    # --- 同步啟動 sar 監控 ---
    LC_ALL=C sar -u 1 15 > "$TEMP_WORKDIR/sar_out.txt" 2>/dev/null &
    local monitor_pid=$!
    sleep 0.5 # 確保 sar 啟動

    # --- 執行 cyclictest ---
    local raw_output=$(cyclictest --smp -p80 -i500 -d10 -l10000 -m 2>/dev/null | grep '^T:' | tail -n "$cpu_count")

    # --- 停止監控並等待 ---
    kill $monitor_pid 2>/dev/null
    wait $monitor_pid 2>/dev/null

    # --- 格式化 cyclictest 輸出 ---
    local poetic_output=$(echo "$raw_output" | awk '{
      min=""; avg=""; max="";
      for(i=1; i<=NF; i++) { if($i == "Min:") min=$(i+1); if($i == "Avg:") avg=$(i+1); if($i == "Max:") max=$(i+1); }
      printf "T%-2s Min: %-5s Avg: %-5s Max: %-5s\n", $2, min, avg, max
    }')
    echo "$poetic_output"
    all_poetic_outputs+="[Round $i]\n$poetic_output\n"

    # --- 提取並記錄本輪最大延遲 ---
    local run_max_latency=$(echo "$raw_output" | awk -F'Max: ' '{print $2}' | awk '{print $1}' | sort -rn | head -n1)
    max_latencies+=( "${run_max_latency:-0}" )

    # --- 提取並更新 st 峰值 ---
    local current_max_st=$(awk 'NR>2 && $1!="Average:" && $(NF-1) ~ /^[0-9.]+$/ { steal = $(NF-1); if(steal > max) max = steal } END {print max+0}' "$TEMP_WORKDIR/sar_out.txt")
    rm -f "$TEMP_WORKDIR/sar_out.txt"
    if (( $(echo "$current_max_st > $peak_st_value" | bc -l) )); then
      peak_st_value=$current_max_st
    fi

    # --- 首輪測試後休息 ---
    if [ $i -lt $test_rounds ]; then
      echo -e "$t_post_rest"
      sleep 30
    fi
  done
  
  local latencies_str=$(printf '%s ' "${max_latencies[@]}"; echo)
  local avg_latency=0
  local sum=0
  for val in "${max_latencies[@]}"; do sum=$((sum + val)); done
  avg_latency=$((sum / ${#max_latencies[@]}))

  # --- 第二部分：壓力分析 ---
  echo -e "\n$t_stress_start"
  local stress_threads=$((cpu_count * 8))
  [ $stress_threads -lt 8 ] && stress_threads=8
  [ $stress_threads -gt 32 ] && stress_threads=32
  printf "$t_stress_params\n" "$stress_threads"
  
  local stress_raw_output=$(cyclictest -t $stress_threads -p80 -i500 -d10 -l10000 -m 2>/dev/null | grep '^T:' | tail -n "$stress_threads")
  echo "$stress_raw_output"
  local stress_peak_latency=$(echo "$stress_raw_output" | awk -F'Max: ' '{print $2}' | awk '{print $1}' | sort -rn | head -n1)
  stress_peak_latency=${stress_peak_latency:-0}
  
  all_poetic_outputs+="\n[Stress Test - ${stress_threads} Threads]\n$stress_raw_output\n"

  # --- 第三部分：最終綜合分析 ---
  echo -e "\n--------------------------"
  echo "$t_analysis"
  
  # 1. 報告 st 和延遲數據
  printf "$t_st_report\n" "$peak_st_value"
  printf "$t_lat_report\n" "${latencies_str% }"
  printf "$t_stress_report\n" "$stress_peak_latency"
  echo "---"

  # 2. 生成「誠信度結論」(基於 st 和標準延遲)
  local honesty_conclusion
  if (( $(echo "$peak_st_value >= 2.0" | bc -l) )); then
    honesty_conclusion="$t_conclusion_st_fail"
  else
    if [[ "$avg_latency" -le 1500 ]]; then
      honesty_conclusion="$t_conclusion_lat_exc"
    elif [[ "$avg_latency" -le 4000 ]]; then
      honesty_conclusion="$t_conclusion_lat_good"
    else
      honesty_conclusion="$t_conclusion_lat_bad"
    fi
  fi
  echo -e "$honesty_conclusion"

  # 3. 生成「壓力結論」(基於壓力延遲與標準延遲的比較)
  local stress_conclusion

  # --- [核心修改] ---
  # 新的觸發邏輯：壓力測試的峰值延遲，必須同時小於兩輪靜態測試的最大延遲，才判定為「性能反常」
  if [[ ${#max_latencies[@]} -eq 2 ]] && \
     (( $(echo "$stress_peak_latency < ${max_latencies[0]}" | bc -l) )) && \
     (( $(echo "$stress_peak_latency < ${max_latencies[1]}" | bc -l) )); then
    stress_conclusion="$t_stress_conclusion_abnormal"
  else
    # 如果不滿足反常條件，則沿用原有的比例比較邏輯，但基準改為 avg_latency
    local ratio=0
    # 確保 avg_latency 大於 0 避免除零錯誤
    if (( $(echo "$avg_latency > 0" | bc -l) )); then
      ratio=$(echo "scale=2; $stress_peak_latency / $avg_latency" | bc)
    fi
  
    if (( $(echo "$ratio <= 10.0" | bc -l) )); then
      stress_conclusion="$t_stress_conclusion_low_impact"
    elif (( $(echo "$ratio <= 30.0" | bc -l) )); then
      stress_conclusion="$t_stress_conclusion_high_impact"
    else
      stress_conclusion="$t_stress_conclusion_bottleneck"
    fi
  fi
  echo -e "$stress_conclusion"
  # --- 寫入報告 ---
  {
    echo ""
    echo "$t_title"
    echo "$t_params"
    echo '```'
    echo -e "$all_poetic_outputs" # 包含了标准测试和压力测试的所有原始输出
    echo '```'
    echo ""
    # --- 写入与终端完全一致的分析结论 ---
    printf "$t_st_report\n" "$peak_st_value"
    printf "$t_lat_report\n" "${latencies_str% }"
    printf "$t_stress_report\n" "$stress_peak_latency"
    echo ""
    echo "---"
    echo ""
    echo -e "**$honesty_conclusion**"
    echo -e "**$stress_conclusion**"
  } >> "$report"
}

ip_quality() {
  # --- 設定 ---
  local RESULT_DIR="$HOME/result"
  local OFFICIAL_ANSI_OUTPUT="$TEMP_WORKDIR/ip.ansi"
  local TEMP_HTML="$TEMP_WORKDIR/temp_report.html"
  local FINAL_IMAGE_FILE="${RESULT_DIR}/IP.png"

  echo -e "${CYAN}$ip_quality_1...${RESET}"
  
  mkdir -p "$RESULT_DIR"

  case $lang in
  us)
    ipcecek='-l en'
  esac
  
  bash <(curl -Ls https://IP.Check.Place) $ipcecek -y -p -o $OFFICIAL_ANSI_OUTPUT >/dev/null 2>&1
  cat $OFFICIAL_ANSI_OUTPUT

  aha --title "$ip_quality_2" < "$OFFICIAL_ANSI_OUTPUT" > "$TEMP_HTML"
  
  sed -i '/<head>/a \
    <style type="text/css"> \
      body { background-color: #1e1e1e !important; font-family: "Noto Color Emoji", "DejaVu Sans Mono", "Courier New", monospace; padding: 25px; } \
      pre { color: #d8d8d8; white-space: pre-wrap; word-wrap: break-word; font-size: 14px; line-height: 1.4; } \
      \
      /* 覆寫內聯樣式 - 提高對比度配色 */ \
      span[style*="color:red"] { color: #f07178 !important; } \
      span[style*="color:green"] { color: #a6e22e !important; } \
      span[style*="color:teal"] { color: #66d9ef !important; } \
      span[style*="color:olive"] { color: #d4a72c !important; } \
      span[style*="color:dimgray"] { color: #75715e !important; } \
      span[style*="color:gray"] { color: #c0c0c0 !important; } \
      \
      /* 背景色調整 - 更高對比度 */ \
      span[style*="background-color:red"] { background-color: #d73a49 !important; } \
      span[style*="background-color:green"] { background-color: #28a745 !important; } \
      span[style*="background-color:olive"] { background-color: #9a7b2e !important; } \
    <\/style>' "$TEMP_HTML"

  wkhtmltoimage \
    --width 1200 \
    --quality 100 \
    --encoding utf-8 \
    "$TEMP_HTML" \
    "$FINAL_IMAGE_FILE" >/dev/null 2>&1
  compress_png $FINAL_IMAGE_FILE
}

net_quality() {
  # --- 設定 ---
  local RESULT_DIR="$HOME/result"
  local OFFICIAL_ANSI_OUTPUT="$TEMP_WORKDIR/net.ansi"
  local TEMP_HTML="$TEMP_WORKDIR/temp_net_report.html"
  local FINAL_IMAGE_FILE="${RESULT_DIR}/net.png"

  echo -e "${CYAN}$net_quality_1...${RESET}"
  
  mkdir -p "$RESULT_DIR"

  case $lang in
  us)
    netcecek='-l en'
  esac

  bash <(curl -Ls https://Net.Check.Place) $netcecek -p -y -o $OFFICIAL_ANSI_OUTPUT >/dev/null 2>&1
  cat $OFFICIAL_ANSI_OUTPUT

  aha --title "$net_quality_2" < "$OFFICIAL_ANSI_OUTPUT" > "$TEMP_HTML"
  
  sed -i '/<head>/a \
    <style type="text/css"> \
      body { background-color: #1e1e1e !important; font-family: "Noto Color Emoji", "DejaVu Sans Mono", "Courier New", monospace; padding: 25px; } \
      pre { color: #d8d8d8; white-space: pre-wrap; word-wrap: break-word; font-size: 14px; line-height: 1.4; } \
      \
      /* 覆寫內聯樣式 - 提高對比度配色 */ \
      span[style*="color:red"] { color: #f07178 !important; } \
      span[style*="color:green"] { color: #a6e22e !important; } \
      span[style*="color:blue"] { color: #61afef !important; } \
      span[style*="color:cyan"] { color: #66d9ef !important; } \
      span[style*="color:teal"] { color: #66d9ef !important; } \
      span[style*="color:yellow"] { color: #e6db74 !important; } \
      span[style*="color:olive"] { color: #e6db74 !important; } \
      span[style*="color:purple"] { color: #c678dd !important; } \
      span[style*="color:magenta"] { color: #c678dd !important; } \
      span[style*="color:dimgray"] { color: #75715e !important; } \
      span[style*="color:gray"] { color: #c0c0c0 !important; } \
      span[style*="color:white"] { color: #d8d8d8 !important; } \
      \
      /* 背景色調整 - 更高對比度 */ \
      span[style*="background-color:red"] { background-color: #d73a49 !important; } \
      span[style*="background-color:green"] { background-color: #28a745 !important; } \
      span[style*="background-color:blue"] { background-color: #3a5a7a !important; } \
      span[style*="background-color:cyan"] { background-color: #3a5a6a !important; } \
      span[style*="background-color:olive"] { background-color: #b58900 !important; } \
      span[style*="background-color:yellow"] { background-color: #b58900 !important; } \
      \
      /* 加強底線效果 */ \
      span[style*="text-decoration:underline"] { \
        text-decoration-thickness: 2px !important; \
        text-decoration-color: currentColor !important; \
        text-underline-offset: 2px !important; \
      } \
    <\/style>' "$TEMP_HTML"

  wkhtmltoimage \
    --width 1200 \
    --quality 100 \
    --encoding utf-8 \
    "$TEMP_HTML" \
    "$FINAL_IMAGE_FILE" >/dev/null 2>&1
  compress_png $FINAL_IMAGE_FILE
}
net_rounting() {
  if [[ "$lang" != cn ]]; then
    return 0
  fi
  # --- 設定 ---
  local RESULT_DIR="$HOME/result"
  local OFFICIAL_ANSI_OUTPUT="$TEMP_WORKDIR/rounting.ansi"
  local TEMP_HTML="$TEMP_WORKDIR/temp/rounting.html"
  local FINAL_IMAGE_FILE="${RESULT_DIR}/CN_rounting.png"

  echo -e "${CYAN}开始执行路由追踪检测（需10-20分钟）${RESET}"
  
  mkdir -p "$RESULT_DIR"
  
  bash <(curl -Ls https://Net.Check.Place) -R -p -y -o $OFFICIAL_ANSI_OUTPUT >/dev/null 2>&1
  cat $OFFICIAL_ANSI_OUTPUT

  aha --title "路由追踪报告" < "$OFFICIAL_ANSI_OUTPUT" > "$TEMP_HTML"
  
  sed -i '/<head>/a \
    <style type="text/css"> \
      body { background-color: #1e1e1e !important; font-family: "Noto Color Emoji", "DejaVu Sans Mono", "Courier New", monospace; padding: 25px; } \
      pre { color: #d8d8d8; white-space: pre-wrap; word-wrap: break-word; font-size: 14px; line-height: 1.4; } \
      \
      /* 覆寫內聯樣式 - 柔和配色（完整版） */ \
      span[style*="color:red"] { color: #e06c75 !important; } \
      span[style*="color:green"] { color: #98c379 !important; } \
      span[style*="color:blue"] { color: #61afef !important; } \
      span[style*="color:cyan"] { color: #56b6c2 !important; } \
      span[style*="color:teal"] { color: #56b6c2 !important; } \
      span[style*="color:yellow"] { color: #e5c07b !important; } \
      span[style*="color:olive"] { color: #d19a66 !important; } \
      span[style*="color:purple"] { color: #c678dd !important; } \
      span[style*="color:magenta"] { color: #c678dd !important; } \
      span[style*="color:dimgray"] { color: #5c6370 !important; } \
      span[style*="color:gray"] { color: #abb2bf !important; } \
      span[style*="color:white"] { color: #d8d8d8 !important; } \
      \
      /* 背景色調整 */ \
      span[style*="background-color:red"] { background-color: #be5046 !important; } \
      span[style*="background-color:green"] { background-color: #5a8a4a !important; } \
      span[style*="background-color:blue"] { background-color: #3a5a7a !important; } \
      span[style*="background-color:cyan"] { background-color: #3a5a6a !important; } \
      span[style*="background-color:olive"] { background-color: #8a7a3a !important; } \
      span[style*="background-color:yellow"] { background-color: #8a7a3a !important; } \
    <\/style>' "$TEMP_HTML"


  wkhtmltoimage \
    --width 1200 \
    --quality 100 \
    --encoding utf-8 \
    "$TEMP_HTML" \
    "$FINAL_IMAGE_FILE" >/dev/null 2>&1
  compress_png $FINAL_IMAGE_FILE
}
streaming_unlock() {
  local RAW_ANSI_OUTPUT="${TEMP_WORKDIR}/streaming_report.ansi"
  local TEMP_HTML="${TEMP_WORKDIR}/streaming_report.html"
  local RESULT_DIR="$HOME/result"
  local FINAL_IMAGE_FILE="${RESULT_DIR}/streaming.png"
  
  echo -e "${CYAN}$streaming_unlock_1...${RESET}"

  mkdir -p "$RESULT_DIR"

  # 執行指令並捕獲輸出
  script -qfc "bash <(curl -L -s check.unlock.media) -E en -R 0" /dev/null > "$RAW_ANSI_OUTPUT"
  
  # 過濾輸出：從第一個 "** Checking Results Under" 開始，
  # 直到 "Testing Done!" 的前一行（也就是最後一個 "===" 行）
  awk '
    /\*\* Checking Results Under/ { found=1 }
    found {
      if (/Testing Done!/) { exit }
      print
    }
  ' "$RAW_ANSI_OUTPUT" > "${RAW_ANSI_OUTPUT}.tmp"
  
  # 檢查過濾是否成功，避免後續步驟出錯
  if [ ! -s "${RAW_ANSI_OUTPUT}.tmp" ]; then
    echo "過濾日誌失敗，請檢查 RAW_ANSI_OUTPUT 內容和 awk 邏輯。"
    return 1
  fi
  
  mv "${RAW_ANSI_OUTPUT}.tmp" "$RAW_ANSI_OUTPUT"
  
  cat "$RAW_ANSI_OUTPUT"
  
  # 轉換為 HTML
  aha --title "$streaming_unlock_2" < "$RAW_ANSI_OUTPUT" > "$TEMP_HTML"

  # 注入樣式和截圖（後續代碼保持不變）
  sed -i '/<head>/a \
    <style type="text/css"> \
      body { background-color: #1e1e1e !important; font-family: "DejaVu Sans Mono", "Courier New", monospace; padding: 25px; } \
      pre { color: #d8d8d8; white-space: pre-wrap; word-wrap: break-word; font-size: 14px; line-height: 1.4; } \
      span[style*="color:red"] { color: #e06c75 !important; } \
      span[style*="color:green"] { color: #98c379 !important; } \
      span[style*="color:teal"] { color: #56b6c2 !important; } \
      span[style*="color:olive"] { color: #d19a66 !important; } \
      span[style*="color:dimgray"] { color: #5c6370 !important; } \
      span[style*="color:gray"] { color: #abb2bf !important; } \
      span[style*="background-color:red"] { background-color: #be5046 !important; } \
      span[style*="background-color:green"] { background-color: #5a8a4a !important; } \
      span[style*="background-color:olive"] { background-color: #8a7a3a !important; } \
    <\/style>' "$TEMP_HTML"
    
  wkhtmltoimage \
    --width 800 \
    --quality 100 \
    --encoding utf-8 \
    "$TEMP_HTML" \
    "$FINAL_IMAGE_FILE" >/dev/null 2>&1
  compress_png $FINAL_IMAGE_FILE
}
speedtest_data() {
  local raw_data="$1"
  local server_city="$2" 
  local processed_data=$(echo "$raw_data" | \
    grep -v "FAILED" | \
    grep -E "Mbps|Gbps" | \
    awk '
    {
      dl_col = 0; up_col = 0; latency_col = 0; location = "";
      for (i=1; i<=NF; i++) { if ($i=="Mbps" || $i=="Gbps") { if(dl_col==0) dl_col=i-1; else {up_col=i-1; break;} } }
      for (i=1; i<dl_col-2; i++) { if ($(i+1)=="ms" || $i=="N/A") { latency_col=i; break; } }
      if (latency_col>0) { for (i=1; i<latency_col; i++) location=location $i " "; } else { for (i=1; i<dl_col-2; i++) location=location $i " "; }
      gsub(/^[ \t]+|[ \t]+$/, "", location);
      dl_speed = $(dl_col); dl_unit = $(dl_col+1); up_speed = $(up_col); up_unit = $(up_col+1);
      if (dl_unit=="Gbps") dl_speed*=1000; if (up_unit=="Gbps") up_speed*=1000;
      printf "%.2f|%.2f|%s\n", dl_speed, up_speed, location;
    }
  ')
  local nearest_data_line=$(echo "$processed_data" | grep "|Nearest$")
  local same_city_data_line=$(echo "$processed_data" | grep -i "|$server_city,")
  local other_data_lines=$(echo "$processed_data" | grep -v "|Nearest$" | grep -vi "|$server_city,")
  local final_data_pool="$other_data_lines"
  if [[ -z "$nearest_data_line" ]]; then
    final_data_pool+=$'\n'; final_data_pool+="$same_city_data_line"
  elif [[ -z "$same_city_data_line" ]]; then
    local nearest_dl_speed=$(echo "$nearest_data_line" | cut -d'|' -f1)
    local nearest_up_speed=$(echo "$nearest_data_line" | cut -d'|' -f2)
    final_data_pool+=$'\n'; final_data_pool+="$(printf "%.2f|%.2f|%s (本地)\n" "$nearest_dl_speed" "$nearest_up_speed" "$server_city")"
  else
    local nearest_dl_speed=$(echo "$nearest_data_line" | cut -d'|' -f1)
    local same_city_dl_speed=$(echo "$same_city_data_line" | cut -d'|' -f1)
    if (( $(echo "$nearest_dl_speed >= $same_city_dl_speed" | bc -l) )); then
      local nearest_up_speed=$(echo "$nearest_data_line" | cut -d'|' -f2)
      final_data_pool+=$'\n'; final_data_pool+="$(printf "%.2f|%.2f|%s (本地)\n" "$nearest_dl_speed" "$nearest_up_speed" "$server_city")"
    else
      final_data_pool+=$'\n'; final_data_pool+="$same_city_data_line"
    fi
  fi



  # 步驟 3: 排序與篩選 (修正重複定義問題)
  local final_data_pool_clean=$(echo "$final_data_pool" | grep -v '^[[:space:]]*$')
  local sorted_data=$(echo "$final_data_pool_clean" | sort -t'|' -k1,1nr)
  local top_10=$(echo "$sorted_data" | head -n 10)
  local bottom_3=$(echo "$sorted_data" | tail -n 3)

  # 步驟 4: 產生 Markdown 表格
  # 根據語言設定表格標題
  case "$lang" in
    cn)
      local t_region="地区"
      local t_download="下载速度"
      local t_upload="上传速度"
      local t_local="(本地)"
      ;;
    us)
      local t_region="Region"
      local t_download="Download Speed"
      local t_upload="Upload Speed"
      local t_local="(Local)"
      ;;
    *)
      local t_region="地區"
      local t_download="下載速度"
      local t_upload="上傳速度"
      local t_local="(本地)"
      ;;
  esac

  # 替換 "(本地)" 標記為對應語言並清理 ANSI 顏色代碼
  local final_output=$(echo "$final_data_pool_clean" | sed "s/(本地)/$t_local/g" | sed 's/\x1b\[[0-9;]*m//g')
  local sorted_clean=$(echo "$final_output" | sort -t'|' -k1,1nr)
  local top_10_clean=$(echo "$sorted_clean" | head -n 10)
  local bottom_3_clean=$(echo "$sorted_clean" | tail -n 3)

  {
    echo "| $t_region | $t_download | $t_upload |"
    echo "|:---|:---|:---|"
    echo "$top_10_clean" | while IFS='|' read -r dl up loc; do
      printf "| %s | %.2f Mbps | %.2f Mbps |\n" "$loc" "$dl" "$up"
    done
    echo "$bottom_3_clean" | while IFS='|' read -r dl up loc; do
      printf "| %s | %.2f Mbps | %.2f Mbps |\n" "$loc" "$dl" "$up"
    done
  }
}

regional_speedtest() {
  local region=""
  local server_city="$1"
  local RESULT_DIR="$HOME/result"
  local output_file="${RESULT_DIR}/regional_net.txt"
  local info=$(curl -s --max-time 4 "https://ipwho.is/?fields=country_code,continent_code")
  local continent_code=$(echo "$info" | jq -r '.continent_code')
  local country_code=$(echo "$info" | jq -r '.country_code')
  if [ -z "$country_code" ] || [ -z "$continent_code" ]; then
    echo -e "${YELLOW}$regional_speedtest_1${RESET}"
    return
  fi
  case "$country_code" in
  CN) region="china" ;;
  IN) region="india" ;;
  RU) region="russia" ;;
  IR) region="iran" ;;
  AE|SA|TR|IL|QA|KW|OM|BH|JO|LB|SY|YE) region="middle-east" ;;  # 常見中東國家
  *)
    # 再用洲別判斷
    case "$continent_code" in
    NA) region="na" ;;
    EU) region="eu" ;;
    AS) region="asia" ;;
    OC) region="au" ;;
    SA) region="sa" ;;
    AF) region="africa" ;;
    *) echo "$regional_speedtest_2"; return ;;
    esac
    ;;
  esac
  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_running="正在执行区域网路测速 (区域: ${region})，这可能需要 5-20 分钟..."
      local t_report="## ${region^^}区域网路速度测试报告 (前10名与后3名)"
      ;;
    us)
      local t_running="Running regional network speed test (region: ${region}), this may take 5-20 minutes..."
      local t_report="## ${region^^} Regional Network Speed Test Report (Top 10 and Bottom 3)"
      ;;
    *)
      local t_running="正在執行區域網路測速 (區域: ${region})，這可能需要 5-20 分鐘..."
      local t_report="## ${region^^}區域網路速度測試報告 (前10名與後3名)"
      ;;
  esac

  echo "$t_running"
  local regional_output=$(wget -qO- nws.sh | bash -s -- -r "$region" 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g')
  echo "$regional_output"

  local speedtest_section=$(echo "$regional_output" | sed -n '/Speedtest.net/,/Avg DL Speed/p' | sed '$d')
    
  {
    echo "$t_report"
    speedtest_data "$speedtest_section" "$server_city"
  } > "$output_file"
}

speedtest_global() {
  local RESULT_DIR="$HOME/result"
  local output_file="${RESULT_DIR}/global_net.txt"
  mkdir -p "$RESULT_DIR"

  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_running="正在执行全球网路测速，这可能需要 15-30 分钟，请耐心等待..."
      local t_report="## 全球网路速度测试报告 (前10名与后3名)"
      local t_warning="警告：侦测到速率限制，将跳过区域测速。"
      ;;
    us)
      local t_running="Running global network speed test. This may take 15-30 minutes, please be patient..."
      local t_report="## Global Network Speed Test Report (Top 10 and Bottom 3)"
      local t_warning="Warning: Rate limiting detected, skipping regional speed test."
      ;;
    *)
      local t_running="正在執行全球網路測速，這可能需要 15-30 分鐘，請耐心等待..."
      local t_report="## 全球網路速度測試報告 (前10名與後3名)"
      local t_warning="警告：偵測到速率限制，將跳過區域測速。"
      ;;
  esac

  echo "$t_running"
  local global_output=$(wget -qO- nws.sh | bash 2>/dev/null | sed 's/\x1b\[[0-9;]*m//g')
  echo "$global_output"

  # 提取關鍵資訊以供後續使用
  local server_city=$(echo "$global_output" | grep "Location" | head -n 1 | awk -F': ' '{print $2}' | awk -F, '{print $1}')
    
  local speedtest_section=$(echo "$global_output" | sed -n '/Speedtest.net/,/Avg DL Speed/p' | sed '$d')
    # 生成全球测速报告
    {
        echo "$t_report"
        echo ""
        speedtest_data "$speedtest_section" "$server_city"
    } > "$output_file"
    
    # 【核心】最终的、更全面的速率限制检查
    if echo "$global_output" | grep -q -i -E "rate limit|throttled|speed cap|FAILED - IP has been rate limited"; then
        echo -e "${YELLOW}$t_warning${RESET}"
    else
        echo "Please wait 10 minutes for the speedtest to rest to avoid rate limiting issues"
        sleep 600
        regional_speedtest "$server_city"
    fi
}

ping_test(){
  local report="$HOME/result/ping.txt"
  mkdir -p "$(dirname "$report")"

  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_start="延迟测试开始"
      local t_title="## 延迟测试"
      local t_region="地区"
      local t_avg_latency="平均延迟"
      local t_packet_loss="丢包率"
      ;;
    us)
      local t_start="Latency test started"
      local t_title="## Latency Test"
      local t_region="Region"
      local t_avg_latency="Average Latency"
      local t_packet_loss="Packet Loss"
      ;;
    *)
      local t_start="延遲測試開始"
      local t_title="## 延遲測試"
      local t_region="地區"
      local t_avg_latency="平均延遲"
      local t_packet_loss="丟包率"
      ;;
  esac

  echo "$t_start"

  case $lang in
  us)
    pinginp="en"
  esac

  # 捕獲腳本輸出
  local ping_output=$(bash <(curl -Ls https://gitlab.com/gebu8f/sh/-/raw/main/testing_server/ping.sh) $pinginp 2>/dev/null)

  # 在終端顯示
  echo "$ping_output"

  # 解析並生成 Markdown
  {
    echo "$t_title"
    echo "| $t_region | $t_avg_latency | $t_packet_loss |"
    echo "|:---|:---|:---|"

    # 跳過表頭行，從測試結果開始解析
    echo "$ping_output" | sed -n '/^------------------------------------------------------------$/,$p' | tail -n +2 | \
      while IFS= read -r line; do
        # 處理空行
        [ -z "$line" ] && continue

        # 從行尾提取丟包率 (最後一個欄位)
        loss=$(echo "$line" | awk '{print $NF}')
        
        # 提取延遲時間 (倒數第三和第二個欄位，例如 "123.456 ms")
        avg=$(echo "$line" | awk '{print $(NF-2), $(NF-1)}')

        # 提取地區名稱 (從頭開始到 IP 位址之前的所有部分)
        # 邏輯：移除最後 4 個欄位 (IP, avg, ms, loss)
        region=$(echo "$line" | awk '{$NF=""; $(NF-1)=""; $(NF-2)=""; $(NF-3)=""; print $0}' | sed 's/[[:space:]]*$//')

        echo "| $region | $avg | $loss |"
      done
  } > "$report"

}
aria2_test(){
  local report_file="$HOME/result/stability_net.txt"
  
  mkdir -p "$(dirname "$report_file")"

  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_prompt="加码测试：这是一个 aria2c 下载 Ubuntu 大档案五次，每次休息三十秒的网路稳定性测试。五次消耗流量大约是29GB。为了避免耗尽您的流量还有被服务商停驶您的伺服器，是否继续？(Y/n) [预设是：N] "
      local t_cancelled="测试已取消。"
      local t_start="网路稳定性加码测试开始，这将需要几分钟时间..."
      local t_title="## 网路稳定性测试"
      local t_complete="网路稳定性测试完成"
      ;;
    us)
      local t_prompt="Bonus test: This is an aria2c download test of Ubuntu large files five times, with a 30-second break between each download for network stability testing. Five downloads consume approximately 29GB of traffic. To avoid exhausting your traffic and having your server suspended by the service provider, do you want to continue? (Y/n) [Default: N] "
      local t_cancelled="Test cancelled."
      local t_start="Network stability bonus test started, this will take a few minutes..."
      local t_title="## Network Stability Test"
      local t_complete="Network stability test completed"
      ;;
    *)
      local t_prompt="加碼測試：這是一個 aria2c 下載 Ubuntu 大檔案五次，每次休息三十秒的網路穩定性測試。五次消耗流量大約是29GB。為了避免耗盡您的流量還有被服務商停駛您的伺服器，是否繼續？(Y/n) [預設是：N] "
      local t_cancelled="測試已取消。"
      local t_start="網路穩定性加碼測試開始，這將需要幾分鐘時間..."
      local t_title="## 網路穩定性測試"
      local t_complete="網路穩定性測試完成"
      ;;
  esac

  # 警告與確認環節
  read -p "$t_prompt" confirm
  confirm=${confirm:-n}
  confirm=${confirm,,}
  if [[ "$confirm" != "y" ]]; then
    echo "$t_cancelled"
    return
  fi

  echo "$t_start"

  # 在報告檔案中先寫入標題和一個換行
  echo -e "$t_title\n" >> "$report_file"

  # 執行遠端腳本，並將其標準輸出通過 tee 分流
  case $lang in
  us)
    final_lang_param="en"
    ;;
  *)
    final_lang_param=""
    ;;
  esac
  
  bash <(curl -Ls https://gitlab.com/gebu8f/sh/-/raw/main/testing_server/final_judgement.sh) $final_lang_param | \
  tee >(sed -n '/^------------------------------------------------------------------$/,$p' > "$report_file")

  echo ""
  echo "$t_complete"
}
all_report() {
  local RESULT_DIR="$HOME/result"
  local report="$HOME/result/report.txt"

  # 根據語言設定文字
  case "$lang" in
    cn)
      local t_basic="## 基础信息"
      local t_ip_quality="## IP质量"
      local t_net_quality="## 网路质量"
      local t_streaming="## 流媒体"
      local t_stability="## 稳定性测试"
      local t_img1="第一个基础信息图片对应到："
      local t_img2="第二个IP质量图片对应到："
      local t_img3="第三个网路质量图片对应到："
      local t_img4="第四个路由追踪图片对应到："
      local t_img5="第五个流媒体图片对应到："
      local t_img4_alt="第四个流媒体图片对应到："
      local t_report_summary="报告总合在："
      local t_batch_reports="分批报告内容在:"
      local t_warning="请记得传到您的装置上再去复制文字，否则可能会错位！"
      ;;
    us)
      local t_basic="## Basic Information"
      local t_ip_quality="## IP Quality"
      local t_net_quality="## Network Quality"
      local t_streaming="## Streaming"
      local t_stability="## Stability Test"
      local t_img1="First basic information image corresponds to:"
      local t_img2="Second IP quality image corresponds to:"
      local t_img3="Third network quality image corresponds to:"
      local t_img4="Fourth route tracing image corresponds to:"
      local t_img5="Fifth streaming image corresponds to:"
      local t_img4_alt="Fourth streaming image corresponds to:"
      local t_report_summary="Summary report at:"
      local t_batch_reports="Batch report contents in:"
      local t_warning="Please remember to transfer to your device before copying text, otherwise it may be misaligned!"
      ;;
    *)
      local t_basic="## 基礎信息"
      local t_ip_quality="## IP質量"
      local t_net_quality="## 網路質量"
      local t_streaming="## 流媒體"
      local t_stability="## 穩定性測試"
      local t_img1="第一個基礎信息圖片對應到："
      local t_img2="第二個IP質量圖片對應到："
      local t_img3="第三個網路質量圖片對應到："
      local t_img4="第四個路由追蹤圖片對應到："
      local t_img5="第五個流媒體圖片對應到："
      local t_img4_alt="第四個流媒體圖片對應到："
      local t_report_summary="報告總合在："
      local t_batch_reports="分批報告內容在:"
      local t_warning="請記得傳到您的裝置上再去複製文字，否則可能會錯位！"
      ;;
  esac

  echo "$t_basic" >> $report
  echo "[IMG 1]" >> $report
  cat $RESULT_DIR/hardware.txt >> $report
  echo "$t_ip_quality" >> $report
  echo "[IMG 2]" >> $report
  echo "$t_net_quality" >> $report
  echo "[IMG 3]" >> $report 
  if [ "$lang" == "cn" ]; then
    echo "## 路由追踪" >> $report
    echo "[IMG 4]" >> $report 
    echo "$t_streaming" >> $report
    echo "[IMG 5]" >> $report
  else
    echo "$t_streaming" >> $report
    echo "[IMG 4]" >> $report
  fi
  cat "$RESULT_DIR/global_net.txt" >> $report
  [ -f $RESULT_DIR/regional_net.txt ] && cat "$RESULT_DIR/regional_net.txt" >> $report
  cat "$RESULT_DIR"/ping.txt >> $report
  [ -f $RESULT_DIR/stability_net.txt ] && {
    echo "$t_stability" >> $report
    cat "$RESULT_DIR/stability_net.txt" >> $report
  }
  echo "$t_img1$RESULT_DIR/base.png"
  echo "$t_img2$RESULT_DIR/IP.png"
  echo "$t_img3$RESULT_DIR/net.png"
  if [[ "$lang" == cn ]]; then
    echo "$t_img4$RESULT_DIR/CN_rounting.png"
    echo "$t_img5$RESULT_DIR/streaming.png"
  else
    echo "$t_img4_alt$RESULT_DIR/streaming.png"
  fi
  echo "$t_report_summary$report"
  echo "$t_batch_reports$RESULT_DIR folder（資料夾）"
  echo -e "${YELLOW}$t_warning${RESET}"
}
case $1 in
-V|-v|--version)
  echo "MatrixBench Version: $version"
  exit 0
  ;;
esac
curl -s --connect-timeout 3 https://api4.ipify.org >/dev/null || { echo "${RED}You do not have ipv4, this script must require ipv4 to work properly${RESET}"; exit 1; }

TEMP_WORKDIR=$(mktemp -d)
trap 'rm -rf "$TEMP_WORKDIR"' EXIT
# 初始化
check_system
check_app
# --- Flag 初始化 ---
do_hw=false
do_ip=false
do_nq=false
do_nr=false
do_stream=false
do_speedtest=false
do_ping=false
do_stability=false
do_oversell=false
# 在你的參數解析 while 循環之前
if [[ "$1" == "--install" ]]; then
  echo "Setting up 'mb' command..."
  # 創建上面那個迷你啟動器的內容
  LAUNCHER_CONTENT='#!/bin/bash\nSOURCE_URL="https://gitlab.com/gebu8f/sh/-/raw/main/testing_server/test.sh"\nexec bash <(curl -sL "$SOURCE_URL") "$@"'
  
  echo -e "$LAUNCHER_CONTENT" | sudo tee /usr/local/bin/mb > /dev/null
  chmod +x /usr/local/bin/mb
  
  # 檢查是否成功
  if command -v mb &> /dev/null; then
    echo "Success! You can now use 'mb' command globally."
    echo "Example: mb -oversell"
  else
    echo "Failed to set up 'mb' command."
  fi
  exit 0 # 完成安裝後退出
fi

# --- 參數解析 ---
while [[ $# -gt 0 ]]; do
  case "$1" in
    -l)
      [[ $2 == cn ]] && lang=cn
      [[ $2 == en ]] && lang=us
      shift 2
      ;;
    -hw)
      do_hw=true
      run_all=false
      shift
      ;;
    -oversell)
      do_oversell=true
      run_all=false
      shift
      ;;
    -ip)
      do_ip=true
      run_all=false
      shift
      ;;
    -nq)
      do_nq=true
      run_all=false
      shift
      ;;
    -nr)
      do_nr=true
      run_all=false
      shift
      ;;
    -stream)
      do_stream=true
      run_all=false
      shift
      ;;
    -speedtest)
      do_speedtest=true
      run_all=false
      shift
      ;;
    -ping)
      do_ping=true
      run_all=false
      shift
      ;;
    -stability)
      do_stability=true
      run_all=false
      shift
      ;;
    *)
      echo "Invalid parameters: $1"
      exit 1
      ;;
  esac
done
lang
# --- 執行對應功能 ---
if $run_all; then
  ecs_download
  ecs_simple_static
  hardware_benchmarks
  cpu_test
  cpu_oversell_test
  ip_quality
  net_quality
  net_rounting
  streaming_unlock
  speedtest_global
  ping_test
  aria2_test
  all_report
else
  if $do_hw; then
    ecs_download
    ecs_simple_static
    hardware_benchmarks
    cpu_test
    cpu_oversell_test
  fi
  
  if $do_oversell; then
    cpu_test
    cpu_oversell_test
  fi

  if $do_ip; then
    ip_quality
  fi

  if $do_nq; then
    net_quality
  fi

  if $do_nr; then
    net_rounting
  fi

  if $do_stream; then
    streaming_unlock
  fi

  if $do_speedtest; then
    speedtest_global
  fi

  if $do_ping; then
    ping_test
  fi

  if $do_stability; then
    aria2_test
  fi
  echo "所有數據都在$HOME/result資料夾"
  echo "All data is in the $HOME/result folder"
fi
  