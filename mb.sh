#!/bin/bash

# 檢測硬碟空間
REQUIRED_SPACE=2097152
CHECK_PATH="/srv"
AVAILABLE_SPACE=$(df -k "$CHECK_PATH" | awk 'NR==2 {print $4}')
if ! [ "$AVAILABLE_SPACE" -ge "$REQUIRED_SPACE" ]; then
  echo "錯誤：磁碟空間不足，至少需要 2GB。（Error: Not enough disk space. At least 2GB is required.）"
  exit 1
fi

mkdir -p /srv/bench_os
check_system(){
  if command -v apt >/dev/null 2>&1; then
    system=1
  elif command -v yum >/dev/null 2>&1; then
    system=2
  elif command -v apk >/dev/null 2>&1; then
    system=3
  elif command -v pkg >/dev/null 2>&1; then
    system=4
  else
    echo "不支援的系統。"
    exit 1
  fi
}
check_system
check_app(){
  local install_list=""
  
  # 檢查 tar
  if ! command -v tar >/dev/null 2>&1; then
    install_list+=" tar"
  fi
  if ! command -v wget >/dev/null 2>&1; then
    install_list+=" wget"
  fi

  # 檢查 xz (很多精簡版系統 tar 有了但沒 xz 引擎)
  if ! command -v xz >/dev/null 2>&1; then
    case $system in
      1) install_list+=" xz-utils" ;;
      2) install_list+=" xz" ;;
      3) install_list+=" xz" ;;
      4) install_list+=" xz" ;;
    esac
  fi

  if [ -n "$install_list" ]; then
    case "$system" in
      1) apt update && apt install -y $install_list ;;
      2) dnf install -y $install_list ;;
      3) apk add $install_list ;;
      4) pkg install -y $install_list ;;
    esac
  fi
}
check_app

curl -sL "https://le4-0-104-146gamut.pulsedmedia.com/public-gebu8f/bench_os.tar.xz" -o /tmp/bench_os.tar.xz 
tar -xJf /tmp/bench_os.tar.xz -C /srv/bench_os
if [ -d "/srv/bench_os" ]; then
  rm -f /tmp/bench_os.tar.xz
fi
mount -t proc /proc "/srv/bench_os/proc"
mount -t sysfs /sys "/srv/bench_os/sys"
mount --make-rslave "/srv/bench_os/sys"
mount --rbind /dev "/srv/bench_os/dev"
mount --make-rslave "/srv/bench_os/dev"
mount --bind /run "/srv/bench_os/run"
mount --make-slave "/srv/bench_os/run"
# 在進入 chroot 之前執行
if [ -f "/etc/resolv.conf" ]; then
  cat /etc/resolv.conf > "/srv/bench_os/etc/resolv.conf"
else
  echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > "/srv/bench_os/etc/resolv.conf"
fi

chroot /srv/bench_os bash <(curl -sL "https://gitlab.com/gebu8f/sh/-/raw/main/testing_server/mb-test.sh") "$@"
mkdir -p "$HOME/result"
cp -a /srv/bench_os/root/result/* "$HOME/result/"
cp -f /srv/bench_os/var/log/matrixbench_error.log /var/log/matrixbench_error.log 
rm -rf /srv/bench_os/root/result/*
chattr -i -a /srv/bench_os/etc/sys_net_check/is_bgp_query 2>/dev/mull 

TARGET="/srv/bench_os"
SUCCESS=0

# 需要檢查的掛載點列表
MOUNT_POINTS="/dev/pts /dev /proc /sys /run"

for mnt in $MOUNT_POINTS; do
    FULL_PATH="${TARGET}${mnt}"
    umount -l "$FULL_PATH" 2>/dev/null
    sleep 0.1
    if grep -q " $FULL_PATH " /proc/mounts; then
      echo "嚴重錯誤：掛載點 $FULL_PATH 依然存在！（Critical error: Mount point $FULL_PATH still exists!）"
      SUCCESS=1
      break
    fi
done

if ! [ $SUCCESS -eq 0 ]; then
  echo "警告：卸載流程中斷，請手動檢查 /proc/mounts！（Warning: The unloading process was interrupted. Please check /proc/mounts manually!）"
  exit 1
fi
if [ -d "$TARGET/proc" ] && [ "$(ls -A $TARGET/proc)" ]; then
    echo "/proc 裡面還有東西，拒絕執行刪除！（There are still files in /proc, so deletion is refused!）"
    exit 1
fi
rm -rf /srv/bench_os
