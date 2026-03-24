PUBLIC_IP_CACHE="$HOME/.zsh_public_ip_cache"

# 如果没有缓存，联网抓取一次公网 IP
if [[ ! -f "$PUBLIC_IP_CACHE" ]]; then
    _pub_ip=$(curl -s --connect-timeout 2 ip.fm | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    if [[ -n "$_pub_ip" ]]; then
        echo "export MY_PUBLIC_IP='$_pub_ip'" > "$PUBLIC_IP_CACHE"
    fi
fi

# 加载缓存
[ -f "$PUBLIC_IP_CACHE" ] && source "$PUBLIC_IP_CACHE"