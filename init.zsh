# 自动获取当前脚本所在目录
D="${0:h}"

# 1. 优先加载 IP 逻辑 (确保变量进入环境)
[[ -f "$D/my-logic.zsh" ]] && source "$D/my-logic.zsh"

# 2. 加载主题文件
if [[ -f "$D/myys.zsh-theme" ]]; then
    source "$D/myys.zsh-theme"
elif [[ -f "$D/zsh-theme-myys.zsh-theme" ]]; then
    source "$D/zsh-theme-myys.zsh-theme"
fi
