# If you come from bash you might have to change your $PATH
export TERM="xterm-256color"
export PATH=$HOME/bin:/usr/local/bin:$PATH

export ZSH="/Users/dev/.oh-my-zsh"
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport"
alias vi="mvim -v"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_MODE="nerdfont-complete"
prompt_zsh_showStatus () {
  state=`osascript -e 'tell application "Spotify" to player state as string'`;
  if [ $state = "playing" ]; then
    artist=`osascript -e 'tell application "Spotify" to artist of current track as string'`;
    track=`osascript -e 'tell application "Spotify" to name of current track as string'`;

    echo -n "  \UF1BC - $artist - $track";
  fi
}
zsh_internet_signal(){
  #source on quality levels - http://www.wireless-nets.com/resources/tutorials/define_SNR_values.html
  #source on signal levels  - http://www.speedguide.net/faq/how-to-read-rssisignal-and-snrnoise-ratings-440
  local signal=$(airport -I | grep agrCtlRSSI | awk '{print $2}' | sed 's/-//g')
  local noise=$(airport -I | grep agrCtlNoise | awk '{print $2}' | sed 's/-//g')
  local SNR=$(bc <<<"scale=2; $signal / $noise")

  local net=$(curl -D- -o /dev/null -s http://www.google.com | grep HTTP/1.1 | awk '{print $2}')
  local color='%F{yellow}'
  local symbol="\uf197"

  # Excellent Signal (5 bars)
  if [[ ! -z "${signal// }" ]] && [[ $SNR -gt .40 ]] ; 
    then color='%F{blue}' ; symbol="\uf1eb" ;
  fi

  # Good Signal (3-4 bars)
  if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .40 ]] && [[ $SNR -gt .25 ]] ; 
    then color='%F{green}' ; symbol="\uf1eb" ;
  fi

  # Low Signal (2 bars)
  if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .25 ]] && [[ $SNR -gt .15 ]] ; 
    then color='%F{yellow}' ; symbol="\uf1eb" ;
  fi

  # Very Low Signal (1 bar)
  if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .15 ]] && [[ $SNR -gt .10 ]] ; 
    then color='%F{red}' ; symbol="\uf1eb" ;
  fi

  # No Signal - No Internet
  if [[ ! -z "${signal// }" ]] && [[ ! $SNR -gt .10 ]] ; 
    then color='%F{red}' ; symbol="\uf011";
  fi

  if [[ -z "${signal// }" ]] && [[ "$net" -ne 200 ]] ; 
    then color='%F{red}' ; symbol="\uf011" ;
  fi

  # Ethernet Connection (no wifi, hardline)
  if [[ -z "${signal// }" ]] && [[ "$net" -eq 200 ]] ; 
    then color='%F{blue}' ; symbol="\uf197" ;
  fi

  echo -n "%{$color%}$symbol " # \f1eb is wifi bars
}


POWERLEVEL9K_CONTEXT_TEMPLATE="%n"
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_SHORTEN_DIR_LENGTH=10
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_middle"
POWERLEVEL9K_TIME_FORMAT="%D{%l:%M:%p}"
POWERLEVEL9K_STATUS_VERBOSE=false
POWERLEVEL9K_STATUS_OK_IN_NON_VERBOSE=true
POWERLEVEL9K_CUSTOM_INTERNET_SIGNAL="zsh_internet_signal"
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(time zsh_showStatus)

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git 
          wd 
          z
          zsh-syntax-highlighting 
          osx 
          npm 
          lol 
          jsontools 
          extract 
          copyfile 
          virtualenv 
          python 
          pyenv 
          colorize 
          tmux
          common-aliases
          catimg
          emoji-clock
          brew
          vundle
          ) 
export PATH=/usr/local/bin:$PATH
source $ZSH/oh-my-zsh.sh
source $ZSH/custom/plugins/antigen.zsh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
source /usr/local/opt/powerlevel9k/powerlevel9k.zsh-theme
export HOMEBREW_GITHUB_API_TOKEN=a95728af8a12638cb003b56ae7124bd2107f2367

lazynvm() {
  unset -f nvm node npm
  export NVM_DIR=~/.nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
}

nvm() {
  lazynvm
  nvm $@
}

node() {
  lazynvm
  node $@
}

npm() {
  lazynvm
  npm $@
}
