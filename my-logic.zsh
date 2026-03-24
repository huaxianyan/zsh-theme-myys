# 1. 定义本地缓存文件路径
LOCAL_ENV_CACHE="$HOME/.zsh_device_cache"

# 2. 如果缓存不存在，则获取一次 IP 并写入
if [[ ! -f "$LOCAL_ENV_CACHE" ]]; then
    echo "# Device specific cache" > "$LOCAL_ENV_CACHE"
    # 获取内网 IP
    _ip=$(hostname -I | awk '{print $1}')
    echo "export MY_STATIC_IP='$_ip'" >> "$LOCAL_ENV_CACHE"
    # 根据主机名设默认符号（可选）
    [[ "$HOST" == "Shiva" ]] && echo "export MY_CUSTOM_SYMBOL='❯'" >> "$LOCAL_ENV_CACHE"
fi

# 3. 加载缓存（瞬时完成）
source "$LOCAL_ENV_CACHE"