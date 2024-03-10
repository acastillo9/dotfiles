### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
set --export --prepend PATH "/Users/andrescastillo/.rd/bin"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)
set -gx EDITOR nvim

starship init fish | source

### NVM
set -gx NVM_DIR (brew --prefix nvm)

### Java
set -gx JAVA_HOME (brew --prefix java)

### Python
set -gx PYENV_ROOT (pyenv root)
set -gx PATH $PYENV_ROOT/shims $PATH
