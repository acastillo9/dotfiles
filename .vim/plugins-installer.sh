# Init the Git repository in package folder
cd ~/.vim
mkdir -p pack
cd pack
git init

# Plugins

# NERDTree
git submodule add https://github.com/scrooloose/nerdtree plugins/start/nerdtree

# Lightline
git submodule add https://github.com/itchyny/lightline.vim plugins/start/lightline

# Fugitive
git submodule add https://tpope.io/vim/fugitive.git plugins/start/fugitive
vim -u NONE -c "helptags fugitive/doc" -c q

# Update the packages
git submodule update --remote --merge
git commit
