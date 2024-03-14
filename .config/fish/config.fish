### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/andrescastillo/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

starship init fish | source

set fish_greeting ""

set -gx TERM xterm-256color

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
set -gx PATH node_modules/.bin $PATH

### NVM
set -gx NVM_DIR (brew --prefix nvm)

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
