""" Vundle Configs

set nocompatible            " be iMproved, required
filetype off                " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.

" plugin on GitHub repo
" Plugin 'tpope/vim-fugitive'

Plugin 'Valloric/YouCompleteMe'
Plugin 'rust-lang/rust.vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'fatih/vim-go'
Plugin 'w0rp/ale'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

Bundle 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()           " required
filetype plugin indent on   " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

""" My Custom Configs.

command! -range=% -nargs=0 Space2Tab execute
  \ ':silent! <line1>,<line2>s#^\( \{'.&ts.
  \ '\}\)\+#\=repeat("\t", len(submatch(0))/'.&ts.')'

"" Editor.

set encoding=utf-8
set t_Co=256
syntax on

set tabstop=4 shiftwidth=4 expandtab softtabstop=4
set colorcolumn=80

set list
set listchars=tab:▒░,trail:░,eol:✓,precedes:☜,extends:☞,nbsp:░

set ruler
set number

" Underscore should not be skipped.
set iskeyword-=_

"" File-specific.

" Makefile.
autocmd FileType make setlocal noexpandtab
autocmd BufEnter nginx.conf setlocal noexpandtab

" Small indents (2 whitespaces) for Vim script, Lua, JavaScript/CSS/HTML.
autocmd BufEnter .vimrc,*.lua,*.js,*.css,*.html call SetSmallIndentOptions()
function SetSmallIndentOptions()
  setlocal tabstop=2 shiftwidth=2 softtabstop=2
endfunction

" `autopep8' for Python.
autocmd BufWritePost *.py call Autopep8()
function Autopep8()
  execute ':silent %!autopep8 %'
  :w
endfunction

" Indent with tabs, align with spaces in C/C++.
autocmd BufEnter *.c,*.cc,*.h,*.hpp,*.cpp call SetCppOptions()
autocmd BufWritePre *.c,*.cc,*.h,*.hpp,*.cpp Space2Tab
function SetCppOptions()
  nnoremap <buffer> <localleader>c I// <esc>
  nnoremap <buffer> <localleader>C I<esc>xxx
  setlocal cindent
  setlocal cinoptions=(0,u0,U0
endfunction

"" Themes and plugins.

colo molokai
hi Normal ctermbg=NONE

set laststatus=2

python3 from powerline.vim import setup as powerline_setup
python3 powerline_setup()
python3 del powerline_setup

"" Workarounds or fixes.

let g:ycm_global_ycm_extra_conf='~/.ycm_extra_conf.py'
let g:ycm_extra_conf_vim_data = ['&filetype']
let g:ycm_rust_src_path='!rustc --print sysroot'.'/lib/rustlib/src/rust/src'
