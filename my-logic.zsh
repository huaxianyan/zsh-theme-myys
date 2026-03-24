PUBLIC_IP_CACHE="$HOME/.zsh_public_ip_cache"

if [[ ! -f "$PUBLIC_IP_CACHE" ]]; then
    _pub_ip=$(curl -s --connect-timeout 2 ip.fm | grep -o -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}")
    if [[ -n "$_pub_ip" ]]; then
        echo "export MY_PUBLIC_IP='$_pub_ip'" > "$PUBLIC_IP_CACHE"
    fi
fi

[ -f "$PUBLIC_IP_CACHE" ] && source "$PUBLIC_IP_CACHE"