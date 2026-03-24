# ------------------------------------------------------------------------------
# 兼容性补丁：防止函数缺失导致 command not found 报错
# ------------------------------------------------------------------------------
svn_prompt_info() { return }
ys_hg_prompt_info() {
	# make sure this is a hg dir
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

# ------------------------------------------------------------------------------
# VCS 基础样式定义
# ------------------------------------------------------------------------------
YS_VCS_PROMPT_PREFIX1=" %{$reset_color%}on%{$fg[blue]%} "
YS_VCS_PROMPT_PREFIX2=":%{$fg[cyan]%}"
YS_VCS_PROMPT_SUFFIX="%{$reset_color%}"
YS_VCS_PROMPT_DIRTY=" %{$fg[red]%}x"
YS_VCS_PROMPT_CLEAN=" %{$fg[green]%}o"

# Git 变量定义
local git_info='$(git_prompt_info)'
ZSH_THEME_GIT_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}git${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_GIT_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_GIT_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# SVN 变量定义
local svn_info='$(svn_prompt_info)'
ZSH_THEME_SVN_PROMPT_PREFIX="${YS_VCS_PROMPT_PREFIX1}svn${YS_VCS_PROMPT_PREFIX2}"
ZSH_THEME_SVN_PROMPT_SUFFIX="$YS_VCS_PROMPT_SUFFIX"
ZSH_THEME_SVN_PROMPT_DIRTY="$YS_VCS_PROMPT_DIRTY"
ZSH_THEME_SVN_PROMPT_CLEAN="$YS_VCS_PROMPT_CLEAN"

# HG 变量定义
local hg_info='$(ys_hg_prompt_info)'

# Virtualenv 环境显示
virtenv_prompt() {
	[[ -n "${VIRTUAL_ENV:-}" ]] || return
	echo " %{$fg[green]%}${VIRTUAL_ENV:t} %{$reset_color%}%"
}
local venv_info='$(virtenv_prompt)'

# 退出状态码渲染
local exit_code="%(?,,C:%{$fg[red]%}%?%{$reset_color%})"

# ------------------------------------------------------------------------------
# 动态公网 IP 字段
# ------------------------------------------------------------------------------
local ip_part='${MY_PUBLIC_IP:+ %{$fg[blue]\}<${MY_PUBLIC_IP}>%{$reset_color%\}}'

# ------------------------------------------------------------------------------
# 最终 PROMPT 构建 (单引号包裹以保持动态刷新)
# ------------------------------------------------------------------------------
PROMPT='
%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%(#,%{$fg[yellow]%}%n%{$reset_color%},%{$fg[cyan]%}%n) \
%{$reset_color%}@ \
%{$fg[green]%}%m'"${ip_part}"'%{$reset_color%} \
%{$reset_color%}in \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
${svn_info}\
${venv_info}\
 \
[%*] ${exit_code}
%{$terminfo[bold]$fg[green]%}❯ %{$reset_color%}'