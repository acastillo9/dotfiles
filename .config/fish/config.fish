# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/andrescastillo/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

starship init fish | source

set fish_greeting ""

set -gx TERM xterm-256color

set -gx EDITOR nvim

### Java
set -gx JAVA_HOME (brew --prefix openjdk@17)

### Python
set -gx PYENV_ROOT (pyenv root)
set -gx PATH $PYENV_ROOT/shims $PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# Maven
set --export MAVEN_HOME (brew --prefix maven)
set --export CATALINA_OPTS "$CATALINA_OPTS -Xmx2g -XX:MaxMetaspaceSize=512m"
set --export MAVEN_OPTS "-Xms2g -XX:MetaspaceSize=512m -XX:MaxMetaspaceSize=512m -Djava.awt.headless=true"

# Git
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
