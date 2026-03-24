# ------------------------------------------------------------------------------
# 基础设置与补丁
# ------------------------------------------------------------------------------
setopt prompt_subst

# 修复函数缺失报错
svn_prompt_info() { return }

# 动态 IP 渲染函数
ip_prompt() {
    [[ -n "$MY_PUBLIC_IP" ]] && echo "%{$fg[blue]%} <$MY_PUBLIC_IP>%{$reset_color%}"
}

# 虚拟环境渲染
virtenv_prompt() {
    [[ -n "${VIRTUAL_ENV:-}" ]] || return
    echo " %{$fg[green]%}${VIRTUAL_ENV:t} %{$reset_color%}"
}

# HG 状态渲染
ys_hg_prompt_info() {
    if [ -d '.hg' ]; then
        echo -n " %{$reset_color%}on%{$fg[blue]%} hg%{$fg[cyan]%}:$(hg branch 2>/dev/null)"
        if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
            if [ -n "$(hg status 2>/dev/null)" ]; then
                echo -n " %{$fg[red]%}x"
            else
                echo -n " %{$fg[green]%}o"
            fi
        fi
        echo -n "%{$reset_color%}"
    fi
}

# ------------------------------------------------------------------------------
# VCS 样式定义 (Git/SVN)
# ------------------------------------------------------------------------------
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$reset_color%}on%{$fg[blue]%} git%{$fg[cyan]%}:"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}o"

ZSH_THEME_SVN_PROMPT_PREFIX=" %{$reset_color%}on%{$fg[blue]%} svn%{$fg[cyan]%}:"
ZSH_THEME_SVN_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_SVN_PROMPT_DIRTY=" %{$fg[red]%}x"
ZSH_THEME_SVN_PROMPT_CLEAN=" %{$fg[green]%}o"

# ------------------------------------------------------------------------------
# 最终 PROMPT 构建
# ------------------------------------------------------------------------------
# 这样写最稳定，不容易产生乱码
PROMPT='
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$fg[yellow]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}@ \
%{$fg[green]%}%m$(ip_prompt)%{$reset_color%} \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
$(ys_hg_prompt_info)\
$(git_prompt_info)\
$(svn_prompt_info)\
$(virtenv_prompt)\
 \
[%*] %(?,,C:%{$fg[red]%}%?%{$reset_color%})
%{$terminfo[bold]$fg[green]%}❯ %{$reset_color%}'