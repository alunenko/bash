autoload -Uz vcs_info
precmd() {vcs_info}

zstyle ':vcs_info:git:*' formats ' on branch %F{yellow}%b%f'

setopt PROMPT_SUBST
PROMPT='%F{yellow}%n%f in ${PWD/#$HOME/~}${vcs_info_msg_0_} %F{green}>%f '
