{config, pkgs, ...}:

{
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      window_padding_width = 4;
      background_opacity = "0.8";
      editor = "vim";
    };
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = false;
  };

  programs.zsh = {
    enable = true;
    shellAliases = {
      grep = "grep --color=auto";
      fgrep = "fgrep --color=auto";
      egrep = "egrep --color=auto";
      ls = "ls --color=auto";
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
    };
    zplug = {
      enable = true;
      plugins = [
        { name = "plugins/colored-man-pages"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/fzf"; tags = [ from:oh-my-zsh ]; }
        { name = "plugins/git"; tags = [ from:oh-my-zsh ]; }
        { name = "zsh-users/zsh-syntax-highlighting"; }
        { name = "zsh-users/zsh-autosuggestions"; }
        { name = "plugins/colored-man-pages"; tags = [ from:oh-my-zsh ]; }
      ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
      {
        name = "powerlevel10k-config";
        src = ./p10k-config;
        file = "p10k.zsh";
      }
    ];
    initExtra = ''
      typeset -U PATH
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word
      setopt correct

      export PATH="$PATH:$HOME/.local/bin"
      export BROWSER=firefox
      export EDITOR=nvim
      export TERMINAL=kitty
      export PGDATA="$HOME/postgres_data"
      export PGHOST="/tmp"

      ## completion system
      zstyle ':completion:*:approximate:'                 max-errors 'reply=( $((($#PREFIX+$#SUFFIX)/3 )) numeric )' # allow one error for every three characters typed in approximate completer
      zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*\~' # don't complete backup files as executables
      zstyle ':completion:*:correct:*'                    insert-unambiguous true             # start menu completion only if it could find no unambiguous initial string
      zstyle ':completion:*:corrections'                  format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}' #
      zstyle ':completion:*:correct:*'                    original true                       #
      zstyle ':completion:*:default'                      list-colors ''${(s.:.)LS_COLORS}      # activate color-completion(!)
      zstyle ':completion:*:*:cd:*:directory-stack'       menu yes select              # complete 'cd -<tab>' with menu
      zstyle ':completion:*:expand:*'                     tag-order all-expansions            # insert all expansions for expand completer
      zstyle ':completion:*:history-words'                list false                          #
      zstyle ':completion:*:history-words'                menu yes                            # activate menu
      zstyle ':completion:*:history-words'                remove-all-dups yes                 # ignore duplicate entries
      zstyle ':completion:*:history-words'                stop yes                            #
      zstyle ':completion:*'                              matcher-list 'm:{a-z}={A-Z}'        # match uppercase from lowercase
      zstyle ':completion:*:matches'                      group 'yes'                         # separate matches into groups
      zstyle ':completion:*'                              group-name
      if [[ -z "$NOMENU" ]] ; then
        zstyle ':completion:*'                            menu select=2                       # if there are more than 5 options allow selecting from a menu
      else
        setopt no_auto_menu # don't use any menus at all
      fi
      zstyle -e ':completion:*'                           special-dirs '[[ $PREFIX = (../)#(|.|..) ]] && reply=(..)'
      zstyle ':completion:*:messages'                     format '%d'                         #
      zstyle ':completion:*:options'                      auto-description '%d'               #
      zstyle ':completion:*:options'                      description 'yes'                   # describe options in full
      zstyle ':completion:*:processes'                    command 'ps -au$USER'               # on processes completion complete all user processes
      zstyle ':completion:*:*:-subscript-:*'              tag-order indexes parameters        # offer indexes before parameters in subscripts
      zstyle ':completion:*'                              verbose true                        # provide verbose completion information
      zstyle ':completion:*:warnings'                     format $'%{\e[0;31m%}No matches for:%{\e[0m%} %d' # set format for warnings
      zstyle ':completion:*:*:zcompile:*'                 ignored-patterns '(*~|*.zwc)'       # define files to ignore for zcompile
      zstyle ':completion:correct:'                       prompt 'correct to: %e'             #
      zstyle ':completion::(^approximate*):*:functions'   ignored-patterns '_*'    # Ignore completion functions for commands you don't have:

      # complete manual by their section
      zstyle ':completion:*:manuals'                      separate-sections true
      zstyle ':completion:*:manuals.*'                    insert-sections   true
      zstyle ':completion:*:man:*'                        menu yes select

      ## correction
      # run rehash on completion so new installed program are found automatically:
      _force_rehash() {
        (( CURRENT == 1 )) && rehash
        return 1 # Because we didn't really complete anything
      }

      # some people don't like the automatic correction - so run 'NOCOR=1 zsh' to deactivate it
      if [[ -n "$NOCOR" ]] ; then
        zstyle ':completion:*'                            completer _oldlist _expand _force_rehash _complete _files
        setopt nocorrect # do not try to correct the spelling if possible
      else
        #    zstyle ':completion:*' completer _oldlist _expand _force_rehash _complete _correct _approximate _files
        setopt correct  # try to correct the spelling if possible
        zstyle -e ':completion:*'                         completer '
        if [[ $_last_try != "$HISTNO$BUFFER$CURSOR" ]]; then
          _last_try="$HISTNO$BUFFER$CURSOR"
          reply=(_complete _match _prefix _files)
        else
          if [[ $words[1] = (rm|mv) ]]; then
            reply=(_complete _files)
          else
            reply=(_oldlist _expand _force_rehash _complete _correct _approximate _files)
          fi
        fi'
      fi

      # command for process lists, the local web server details and host completion
      zstyle ':completion:*:urls'                         local 'www' '/var/www/' 'public_html'

      # caching
      [ -d $ZSHDIR/cache ] && zstyle ':completion:*'      use-cache yes && \
        zstyle ':completion::complete:*'                  cache-path $ZSHDIR/cache/

      # host completion /* add brackets as vim can't parse zsh's complex cmdlines 8-) {{{ */
      [ -r ~/.ssh/known_hosts ] && _ssh_hosts=(''${''${''${''${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
      [ -r /etc/hosts ] && : ''${(A)_etc_hosts:=''${(s: :)''${(ps:\t:)''${''${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()

      hosts=(`hostname` "$_ssh_hosts[@]" "$_etc_hosts[@]" localhost)
      zstyle ':completion:*:hosts'                        hosts $hosts
    '';
  };
}
