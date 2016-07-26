## Uncomment the following line if you want to use the "command not found" Ubuntu command
#. /etc/zsh_command_not_found

### These are a really nice view of the command line. If you do not like it, comment all lines.

### General config sets
alias ls='ls -G'
alias ll='ls -lG'
### Default definitions
## I use MOST as my default pager. You should too, but it's up to you
PAGER=/usr/bin/most

command_oriented_history=1
HISTCONTROL=ignoreboth
ulimit -c unlimited
umask 022
mesg y

### LS and V aliases
#  Gestion du ls : couleur + touche pas aux accents
# alias ls='ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable'

# Gestion du grep : couleur
alias grep='grep --color=auto'

#alias ls="ls $LS_OPTIONS" #--format=vertical
alias ll="ls $LS_OPTIONS --format=long"
alias messages="multitail /var/log/messages"
alias c="clear"

### Export everything so far
#export PS1 NLSPATH PAGER MAIL LS_COLORS LS_OPTIONS LIBRARY_PATH \
#            C_INCLUDE_PATH CPLUS_INCLUDE_PATH EDITOR TERM XFILESEARCHPATH
export HISTFILE=$HOME/.zsh_history
export HISTSIZE=8192
export SAVEHIST=8192

### CD shortcuts
export CDPATH=.:~

### List of file extensions you wish to ignore on a ls
export FIGNORE="~:.o"

### These are very interesting. I will explain some of them at the end
setopt share_history
setopt appendhistory
setopt autocd
#setopt automenu
setopt autopushd
setopt autoresume
#setopt complete_in_word
setopt extended_glob
setopt hist_ignoredups
setopt hist_ignorespace
setopt list_types
setopt mailwarning
setopt no_flowcontrol
setopt no_hup
setopt no_notify
#setopt printexitvalue
setopt pushd_ignoredups
setopt pushd_silent
# Je ne veux JAMAIS de beeps
unsetopt beep
unsetopt hist_beep
unsetopt list_beep
# Demande confirmation pour 'rm *'
unsetopt rm_star_silent
# Autocompletion style bash
unsetopt list_ambiguous
# Correct all
#setopt correctall
# autocompletion case-insensitive (pour ls, cd etc...)
setopt no_case_glob
setopt extendedhistory


### Making sure your keyboard will work on any terminal
bindkey '^[[1~' beginning-of-line
bindkey '^[[4~' end-of-line
bindkey '^[[2~' overwrite-mode
bindkey '^[[3~' delete-char
bindkey '^[[6~' end-of-history
bindkey '^[[5~' beginning-of-history
bindkey '^[^I' reverse-menu-complete
bindkey '^[OA' up-line-or-history
bindkey '^[[A' up-line-or-history
bindkey '^[[B' down-line-or-history
bindkey '^[OB' down-line-or-history
bindkey '^[OD' backward-char
bindkey '^[OC' forward-char
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward
bindkey '^[[[A' run-help
bindkey '^[[[B' which-command
bindkey '^[[[C' where-is
bindkey '^D' list-choices

#bindkey '\e[5C' forward-word
#bindkey '\e[5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^[[1;5D' backward-word

### See for yourself, at the end
alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias edisplay="export DISPLAY=:0.0"
alias velist="vzlist -o ctid,hostname,description,numproc,status,ip"

### Push History from previous sessions
fc -R $HISTFILE

### Forcing the rehash
_force_rehash() {
  (( CURRENT == 1 )) && rehash
  return 1
}

### Loading the completion style
zstyle ':completion:*' completer \
  _oldlist _expand _force_rehash _complete

### Aliasing "run-help"
#unalias run-help
autoload run-help

### Loading the compinit
autoload -U compinit
compinit

### Git Prompt :
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}


### Useful functions :
dfh()
{
        df -kTh |grep Sys
        df -kTh |grep "/dev/sd"
}

lastMaj()
{
	find / -not -path '/sys*' -not -path '/dev*' -mmin -60
}

#Monitor()
#{
#        echo "wlanconfig ath0 destroy"
#        echo "wlanconfig ath create wlandev wifi0 wlanmode monitor"
#        wlanconfig ath0 destroy
#        wlanconfig ath create wlandev wifi0 wlanmode monitor
#}

extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1        ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1       ;;
             *.rar)       rar x $1     ;;
             *.gz)        gunzip $1     ;;
             *.tar)       tar xf $1        ;;
             *.tbz2)      tar xjf $1      ;;
             *.tgz)       tar xzf $1       ;;
             *.zip)       unzip $1     ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}


if [ `id -u` -eq 0 ]
then
	PROMPT=$'[%*]%{\e[1;31m%} %n %{\e[0m%}$ '
else
	PROMPT=$'[%*]%{\e[0;36m%} %n %{\e[0m%}$ '
fi
RPROMPT=$'$(vcs_info_wrapper) %{\e[0;34m%} %d %{\e[0;36m%}< %U%m%u >%{\e[0m%}'
