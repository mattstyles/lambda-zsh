# ZSH Theme - based on lambda

# Git stuff
get_git_branch() {
  if [[ "$(git config --get oh-my-zsh.hide-status)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return
    echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}

get_git_color() {
  local SUBMODULE_SYNTAX=''
  local GIT_STATUS=''
  local CLEAN_MESSAGE='nothing to commit (working directory clean)'
  if [[ "$(command git rev-parse --short HEAD 2> /dev/null)" != "" ]]; then
    if [[ "$(command git config --get oh-my-zsh.hide-status)" != "1" ]]; then
      if [[ $POST_1_7_2_GIT -gt 0 ]]; then
            SUBMODULE_SYNTAX="--ignore-submodules=dirty"
      fi
      if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
          GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} -uno 2> /dev/null | tail -n1)
      else
          GIT_STATUS=$(command git status -s ${SUBMODULE_SYNTAX} 2> /dev/null | tail -n1)
      fi
      if [[ -n $GIT_STATUS ]]; then
        echo %{$fg[red]%}
      else
        echo %{$fg[green]%}
      fi
    else
      echo %B
    fi
  else
    echo
  fi
}

get_behind_ahead() {
  INDEX=$(command git status --porcelain -b 2> /dev/null)
  STATUS=""
  if $(echo "$INDEX" | grep '^## .*ahead' &> /dev/null); then
    STATUS=" $ZSH_THEME_GIT_PROMPT_AHEAD$STATUS"
  fi
  if $(echo "$INDEX" | grep '^## .*behind' &> /dev/null); then
    STATUS=" $ZSH_THEME_GIT_PROMPT_BEHIND$STATUS"
  fi
  echo $STATUS
}

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"

ZSH_THEME_GIT_PROMPT_BEHIND="%{$fg[red]%}⬇"
ZSH_THEME_GIT_PROMPT_AHEAD="%{$fg[green]%}⬆"


# Spacer aliases - adds space around res
function fnCat() { echo -e && cat "$@" && echo -e; }
function fnLS() { echo -e && ls "$@" && echo -e; }
function fnRM() { echo -e && rm -i "$@" && echo -e; }
function fnGit() { echo -e && git "$@" && echo -e; }
function fnGrunt() { clear && echo -e && grunt "$@" && echo -e; }
alias c=clear
alias cat='fnCat'
alias ls='fnLS'
alias rm='fnRM'
alias grunt='fnGrunt'

# shortcut aliases

# prompts
PROMPT='  $(get_git_color)λ%{$reset_color%} %B%1~ $(get_git_branch)$(get_behind_ahead)%{$reset_color%} '
#RPROMPT='%t $(battery_pct_prompt) %B$(node --version)%{$reset_color%}'
RPROMPT='%t %{$reset_color%}'
#POSTEDIT='
#'
