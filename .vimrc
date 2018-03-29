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

Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
Plugin 'powerline/powerline', {'rtp': 'powerline/bindings/vim/'}

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

set iskeyword-=_
set iskeyword+="。"
set iskeyword+="，"

" Forgot to `sudo'?  Use `w!!'.
cmap w!! w !sudo tee % >/dev/null

" Toggle paste mode.
set pastetoggle=<leader>p

"" File-specific.

" Preserved tabs.
autocmd FileType make setlocal noexpandtab
autocmd BufEnter nginx.conf setlocal noexpandtab

" Small indents (2 whitespaces) e.g. Vim script, Lua, JavaScript/CSS/HTML.
autocmd BufEnter .vimrc,*.lua,*.js,*.css,*.html call SetSmallIndentOptions()
function SetSmallIndentOptions()
  setlocal tabstop=2 shiftwidth=2 softtabstop=2
endfunction

" `black' for Python.
autocmd BufWritePost *.py call PyBlack()
function PyBlack()
  let b:loc=line('.')
  :silent %!black -l 79 % > /dev/null
  :edit!
  execute ':'.b:loc
endfunction

" `rustfmt' for Rust.
autocmd BufWritePost *.rs call Rustfmt()
function Rustfmt()
  let b:loc=line('.')
  :silent %!rustfmt %
  :edit!
  execute ':'.b:loc
endfunction

" Indent with tabs, align with spaces in C/C++.
autocmd BufEnter *.c,*.cc,*.h,*.hpp,*.cpp,*.cxx,*.l,*.y call SetCppOptions()
autocmd BufWritePre *.c,*.cc,*.h,*.hpp,*.cpp,*.cxx,*.l,*.y Space2Tab
function SetCppOptions()
  setlocal cindent
  setlocal cinoptions=(0,u0,U0
  if filereadable('CMakeLists.txt')
    let g:ale_linters={'cpp':[], 'c':[]}
  endif
endfunction

" Comment toggling.
function CommentToggle(cmt)
  let b:cmtlen=strlen(a:cmt) + 1
  execute ':nnoremap <buffer> <localleader>c I'.a:cmt.' <esc>'
  execute ':nnoremap <buffer> <localleader>C ^'.repeat('x', b:cmtlen)
endfunction

autocmd BufEnter .vimrc call CommentToggle('"')
autocmd BufEnter *.lua call CommentToggle('--')
autocmd BufEnter *.go,*.js,*.c,*.cc,*.h,*.hpp,*.cpp,*.cxx,*.l,*.y,*.java,*.rs
  \ call CommentToggle('//')
autocmd BufEnter *.py,*.sh call CommentToggle('#')

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
let g:ycm_rust_src_path=system('echo -n `rustc --print sysroot`')
  \ .'/lib/rustlib/src/rust/src'

" Fix ALE included directories:
" * node-gyp header files
let g:node_gyp_dir=system('echo -n `realpath ~`/.node-gyp/')
let g:node_gyp_latestver=system('echo -n `ls '.g:node_gyp_dir.' | tail -1`')
let g:ale_cpp_clang_options=
  \ '-std=c++14 -Wall'
  \ .' -I'.g:node_gyp_dir.g:node_gyp_latestver.'/include/node'
let g:ale_cpp_gcc_options=g:ale_cpp_clang_options

""" Local settings.

if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif
