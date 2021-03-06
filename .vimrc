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
Plugin 'joom/latex-unicoder.vim'

" plugin from http://vim-scripts.org/vim/scripts.html
" Plugin 'L9'

" Git plugin not hosted on GitHub
" Plugin 'git://git.wincent.com/command-t.git'

" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'

" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
" Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

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

command! -nargs=* -complete=shellcmd Vsh execute "vview | r! <args>"

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

" Ignore large directories in netrw.
let g:netrw_list_hide='node_modules'
let g:netrw_hide=1

" Increment/Decrement a metasyntactic variable.
function! s:IncMetasynVar(step)
  if type(a:step) != type(0)
    return
  endif

  let b:vars = [
    \ 'foo', 'bar', 'baz',
    \ 'qux', 'quux', 'corge',
    \ 'grault', 'garply', 'waldo',
    \ 'fred', 'plugh', 'xyzzy', 'thud'
  \ ]
  let b:cword = expand('<cword>')
  let b:i = index(b:vars, b:cword)

  if b:i == -1
    if a:step > 0
      execute "normal! \<C-a>"
      return
    endif

    execute "normal! \<C-x>"
    return
  endif

  let b:i += a:step

  if b:i == -1
    let b:i = len(b:vars) - 1
  elseif (b:i == len(b:vars))
    let b:i = 0
  endif

  call setreg('w', b:vars[b:i])
  normal! "bviw"wp
endfunction

" Remap inc/dec.
nnoremap <C-a> :call <SID>IncMetasynVar(1)<Enter>
nnoremap <C-x> :call <SID>IncMetasynVar(-1)<Enter>

"" File-specific.

" Preserved tabs.
autocmd FileType make setlocal noexpandtab
autocmd BufEnter nginx.conf setlocal noexpandtab

" Small indents (2 whitespaces) e.g. Vim script, Lua, JavaScript/CSS/HTML.
au BufEnter .vimrc,*.lua,*.js,*.css,*.html,*.agda,*.hs call SetSmallIndent()
function SetSmallIndent()
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

" Haskell formatting.
autocmd BufWritePost *.hs call StylishHaskll()
function StylishHaskll()
  let b:loc=line('.')
  :silent %!stylish-haskell -i % > /dev/null
  :edit!
  execute ':'.b:loc
endfunction

" `html.unescape' for Python.
function PyHtmlUnescape(c)
python3 << EOS
from html import unescape
e = unescape(vim.eval("a:c"))
vim.command("normal a{}".format(e))
EOS
  :startinsert!
endfunction

" `rustfmt' for Rust.
autocmd BufWritePost *.rs call Rustfmt()
function Rustfmt()
  let b:loc=line('.')
  :silent %!rustfmt --unstable-features --config-path ~/.rustfmtrc %
  :edit!
  execute ':'.b:loc
endfunction

" Indent with tabs, align with spaces in C/C++/Java.
au BufEnter *.c,*.cc,*.h,*.hpp,*.cpp,*.cxx,*.l,*.y,*.java call SetCppOptions()
au BufWritePre *.c,*.cc,*.h,*.hpp,*.cpp,*.cxx,*.l,*.y,*.java Space2Tab
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
" Agda syntax file from:
" http://wiki.portal.chalmers.se/agda/pmwiki.php?n=Main.VIMEditing
autocmd BufEnter *.agda setf agda

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
  \ '-std=c++17 -Wall'
  \ .' -I'.g:node_gyp_dir.g:node_gyp_latestver.'/include/node'
let g:ale_cpp_gcc_options=g:ale_cpp_clang_options
let g:ale_cpp_clangtidy_options='--std=c++17'

""" Local settings.

if filereadable("~/.vimrc.local")
  source ~/.vimrc.local
endif
