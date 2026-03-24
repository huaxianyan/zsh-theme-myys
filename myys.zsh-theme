# ------------------------------------------------------------------------------
# Modified YS Theme - Dynamic Version
# Optimized for Zplug & Multi-device Sync (huaxianyan)
# ------------------------------------------------------------------------------

# VCS 基础样式
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}on%{$fg[blue]%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git 信息
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# SVN 信息
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}svn${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG 信息
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
local hg_info='$(ys_hg_prompt_info)'

# Virtualenv
virtenv_prompt() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo " %{$fg[green]%}${VIRTUAL_ENV:t} %{$reset_color%}%"
}
local venv_info='$(virtenv_prompt)'

# 退出码
local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# ------------------------------------------------------------------------------
# 动态变量处理 (核心逻辑)
# ------------------------------------------------------------------------------

# 1. 动态 IP 显示：如果定义了 MY_DISPLAY_IP，则显示 <IP>
# 如果没有定义，这部分就是空的，不会报错
local ip_part="${MY_DISPLAY_IP:+ %{$fg[blue]\}<$MY_DISPLAY_IP>%{$reset_color%\}}"

# 2. 动态用户颜色 (默认青色，Shiva 环境可设为 yellow)
local user_color="${MY_USER_COLOR:-cyan}"

# 3. 动态命令提示符符号 (默认 ❯)
local p_symbol="${MY_PROMPT_SYMBOL:-❯}"

# 4. 动态命令提示符颜色 (默认绿色，如果是 root 或特定设备可设为 red)
local p_color="${MY_SYMBOL_COLOR:-green}"

# ------------------------------------------------------------------------------
# PROMPT 构建
# ------------------------------------------------------------------------------

PROMPT="
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$fg[yellow]%}%n%{$reset_color%},%{$fg[$user_color]%}%n) \
%{$reset_color%}@ \
%{$fg[green]%}%m${ip_part}%{$reset_color%} \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
 \
[%*] $exit_code
%{$terminfo[bold]$fg[$p_color]%}${p_symbol} %{$reset_color%}"