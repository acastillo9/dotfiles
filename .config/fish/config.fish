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
set -gx JAVA_HOME (brew --prefix java)

### Python
set -gx PYENV_ROOT (pyenv root)
set -gx PATH $PYENV_ROOT/shims $PATH
