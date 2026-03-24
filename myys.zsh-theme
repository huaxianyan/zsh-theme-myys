# ------------------------------------------------------------------------------
# 基础设置
# ------------------------------------------------------------------------------
# 必须开启此选项，否则 $(函数) 会被当做纯文本显示
setopt prompt_subst

# 修复函数缺失报错
svn_prompt_info() { return }
ys_hg_prompt_info() {
    if [ -d '.hg' ]; then
        echo -n "${YS_VCS_PROMPT_PREFIX1}hg${YS_VCS_PROMPT_PREFIX2}"
        echo -n $(hg branch 2>/dev/null)
        if [[ "$(hg config oh-my-zsh.hide-dirty 2>/dev/null)" != "1" ]]; then
            if [ -n "$(hg status 2>/dev/null)" ]; then
                echo -n "$YS_VCS_PROMPT_DIRTY"
            else
                echo -n "$YS_VCS_PROMPT_CLEAN"
            fi
        fi
        echo -n "$YS_VCS_PROMPT_SUFFIX"
    fi
}

virtenv_prompt() {
    [[ -n "${VIRTUAL_ENV:-}" ]] || return
    echo " %{$fg[green]%}${VIRTUAL_ENV:t} %{$reset_color%}%"
}

# ------------------------------------------------------------------------------
# VCS 样式定义
# ------------------------------------------------------------------------------
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}on%{$fg[blue]%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

ZSH_THEME_SVN_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}svn${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# ------------------------------------------------------------------------------
# PROMPT 构建
# ------------------------------------------------------------------------------
# 动态 IP 渲染逻辑
local ip_segment='${MY_PUBLIC_IP:+ %{$fg[blue]\}<${MY_PUBLIC_IP}>%{$reset_color%\}}'
# 退出码渲染逻辑
local exit_status="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

PROMPT='
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$fg[yellow]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}@ \
%{$fg[green]%}%m'"${ip_segment}"'%{$reset_color%} \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
$(ys_hg_prompt_info)\
$(git_prompt_info)\
$(svn_prompt_info)\
$(virtenv_prompt)\
 \
[%*] '"${exit_status}"'
%{$terminfo[bold]$fg[green]%}❯ %{$reset_color%}'