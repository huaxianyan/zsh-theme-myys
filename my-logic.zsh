# 定义缓存路径
IP_CACHE="$HOME/.zsh_public_ip_cache"

# 核心逻辑：只有当文件不存在或者文件大小为 0 时，才执行 curl
if [[ ! -s "$IP_CACHE" ]]; then
    # 异步或带超时的获取（防止网络环境差时卡死终端）
    # 使用 ( ... ) & 脱离当前进程或者设置极短的 timeout
    _pub_ip=$(curl -s --connect-timeout 1.5 ip.fm | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    
    if [[ -n "$_pub_ip" ]]; then
        echo "export MY_PUBLIC_IP='$_pub_ip'" > "$IP_CACHE"
        export MY_PUBLIC_IP="$_pub_ip"
    fi
else
    # 如果文件存在且有内容，直接静默加载，耗时几乎为 0ms
    source "$IP_CACHE"
fi

# 定义一个手动更新的别名，如果你换了网络环境（比如从公司回到家），执行一下这个即可
alias refresh_ip="rm -f $IP_CACHE && exec zsh"