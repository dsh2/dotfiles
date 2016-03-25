" Setup Vundle.vim
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/Vundle.vim

" Begin of setup Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'vim-scripts/hexman.vim'

" Git stuff
Plugin 'tpope/vim-fugitive'
nmap <leader>gd :Gvdiff<cr>
nmap <leader>gc :Gcommit --verbose<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gl :
Plugin 'junegunn/gv.vim'
nmap <leader>gv :GV<cr>

Plugin 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black

" Cscope
Plugin 'vim-scripts/cscope-quickfix'
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscoperelative
nnoremap <C-n> :cn<cr>
nnoremap <C-p> :cp<cr>
Plugin 'hari-rangarajan/CCTree' 
let g:CCTreeDisplayMode=1
let g:CCTreeHilightCallTree=1

" Utils
Plugin 'Shougo/vimproc.vim'
Plugin 'vim-scripts/genutils'
Plugin 'vim-scripts/SelectBuf'
Plugin 'tpope/vim-unimpaired'
Plugin 'embear/vim-foldsearch'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rsi'
Plugin 'tpope/vim-eunuch'
Plugin 'dkprice/vim-easygrep'
Plugin 'nelstrom/vim-visual-star-search'

Plugin 'junegunn/vim-peekaboo'
let g:peekaboo_window = 'vertical botright 51new'
let g:peekaboo_delay = 100
let g:peekaboo_compact = 0

Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax' 

Plugin 'junegunn/rainbow_parentheses.vim'

Plugin 'tyru/open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
command! OpenBrowserCurrent execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')
nmap gX OpenBrowserCurrent

Plugin 'vim-scripts/renamer.vim'

" Lua
Plugin 'xolox/vim-lua-ftplugin'
" Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'

Plugin 'tpope/vim-afterimage'
" json
Plugin 'elzr/vim-json'
function! FormatJSON()
		:'<,'>!python -m json.tool
endfunction
map =j :call FormatJSON()<cr>

" NERD Tree
Plugin 'scrooloose/nerdtree'
let NERDTreeIgnore=['\~$[file]', '\.pyc$[file]']
let NERDTreeWinSize=50
autocmd FileType nerdtree map <buffer> l oj^
autocmd FileType nerdtree map <buffer> O mo
autocmd FileType nerdtree map <buffer> h x^
autocmd FileType nerdtree map <buffer> ; go
autocmd FileType nerdtree map <buffer> <F2> :NERDTreeClose<cr>
nnoremap <F2> :NERDTreeFind<cr>
" Plugin 'Xuyuanp/nerdtree-git-plugin'

Plugin 'vim-scripts/indentpython.vim'
" Plugin 'davidhalter/jedi-vim'
" let g:jedi#use_splits_not_buffers = "right"

Plugin 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_lua_checkers = ["luac", "luacheck"]
let g:syntastic_lua_luacheck_args = "--no-unused-args" 

Plugin 'nvie/vim-flake8'
Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-u>'
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F2>'] }
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
let g:ctrlp_extensions = ['tag', 'buffertag', 'quickfix', 'dir', 'rtscript', 'undo', 'line', 'changes', 'mixed', 'bookmarkdir']
let g:ctrlp_line_prefix = '> '
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_cache_dir = $HOME.'/.vim/ctrlp-cache'
let g:ctrlp_open_multiple_files = 'v'
let g:ctrlp_mruf_max = 250

" Plugin 'Valloric/YouCompleteMe'

" Show tags of current file in separat window
Plugin 'vim-scripts/taglist.vim'
let Tlist_Use_Right_Window = 1
let Tlist_WinWidth = 55
let Tlist_Display_Prototype = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_GainFocus_On_ToggleOpen = 0
let Tlist_Highlight_Tag_On_BufEnter = 1
let Tlist_Auto_Open = 1
let Tlist_Show_One_File = 1
map <leader>tt :TlistToggle<cr>

" Highlights words under the cursor
Plugin 'ihacklog/HiCursorWords'
let g:HiCursorWords_delay = 10
let g:HiCursorWords_hiGroupRegexp = ''
let g:HiCursorWords_debugEchoHiName = 0

Plugin 'lzap/vim-selinux'
Plugin 'tpope/vim-dispatch'

" Vim-airline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#ctrlp#color_template = 'visual'
let g:airline#extensions#ctrlp#show_adjacent_modes = 0

" Folding
" Plugin 'tmhedberg/SimpylFold'
" let g:SimpylFold_docstring_preview=1

" Colorschemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
Plugin 'junegunn/seoul256.vim'

Plugin 'vim-scripts/VCard-syntax'
Plugin 'Chiel92/vim-autoformat'

" Comma separated values
Plugin 'chrisbra/csv.vim'
" hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
" hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
" hi link CSVColumnOdd MoreMsg
" hi link CSVColumnEven Question
let g:csv_no_column_highlight = 0
let b:csv_arrange_align = 'llllllll'
let g:csv_autocmd_arrange      = 1

" Undotree
Plugin 'mbbill/undotree'
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

Plugin 'scrooloose/nerdcommenter'

Plugin 'hsanson/vim-android'
let g:android_sdk_path = $ANDROID_SDK_ROOT
let g:android_airline_android_glyph = 'U+f17b'
Plugin 'artur-shaik/vim-javacomplete2'

Plugin 'idanarye/vim-vebugger'
let g:vebugger_leader='<Leader>d'
let g:vebugger_path_gdb='ggdb'

call vundle#end()
filetype plugin indent on
" End of setup Vundle.vim

" Options
set autoindent
set autowrite
set background=dark
set backspace=indent,eol,start
set backupdir=~/.vim/backup/
set cmdheight=1
set cmdwinheight=20
set dir=~/.vim/swo
set encoding=utf8
set exrc
set gdefault
set grepprg=grep\ -nH\ $*
set hidden
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nocompatible
set nowrap
set nowrapscan
set number
set nospell
set previewheight=14
set relativenumber
set ruler
set scrolloff=999
set sidescrolloff=30
set shellslash
set shortmess=filnxtToOI
set showbreak=›
set showcmd
set showfulltag
set showmatch
set sidescroll=15
set smartcase
set smartindent
set smarttab
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set tabstop=4
set ttimeoutlen=50
set title
set updatetime=500
set wildignore=*~,*.o,*.obj,*.aux
set wildmenu
set wildmode=list:longest,full
set winminheight=0

" Enable syntax highlighting
syntax enable
colorscheme solarized
"colorscheme zenburn

" Make 'K' lookup vim help for vim files
autocmd FileType vim setl keywordprg=:help
autocmd FileType help set nonumber
autocmd FileType help set sidescrolloff=0
autocmd FileType help wincmd L

" Open log files at the bottom of the file
autocmd BufReadPost *.log normal G
autocmd BufReadPost *.log :set filetype=messages
autocmd BufRead,BufNewFile *.strace set filetype=strace

" Source vimrc upon saving vimrc
autocmd BufWritePost ~/.vimrc source ~/.vimrc
autocmd BufWritePost ~/.dotfiles/vimrc source ~/.vimrc

" Restore last position in file upon opening a file
autocmd BufReadPost * call RestorePosition()
autocmd VimLeave * mksession! ~/.vim/lastsession

function! RestorePosition()
   if !exists("b:_goto_pos") || b:_goto_po
      if line("'\"") > 0
         if line("'\"") <= line("$")
            execute "norm `\""
         else
            execute "norm $"
         endif
      endif
   else
      let b:_goto_pos = 1
   endif
endfunction

" Add a cursorline(/cursorcolumn) to the active window
"au WinLeave * set nocursorline nocursorcolumn
"au WinEnter * set cursorline cursorcolumn
autocmd WinLeave * set nocursorline
autocmd WinEnter * set cursorline
set nocursorcolumn
set cursorline

" Remove search highlighting by pressing enter key
nnoremap <cr> :nohlsearch<CR>/<BS><CR>

"
" Function key mappings
"
nnoremap <F4> :UndotreeToggle<cr>

" Split navigations
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" Enable spell checking for commit messages
autocmd BufReadPost /tmp/cvs*,svn-commit.tmp*,*hg-editor* setl spell
autocmd BufNewFile,BufReadPost *.git/COMMIT_EDITMSG setf gitcommit | set spell

" vimpager settings
let vimpager_passthrough = 0
let vimpager_scrolloff = 5

" Add support for reading manual pages
runtime! ftplugin/man.vim
autocmd FileType man set sidescrolloff=0

" Enable persistent undo
if has("persistent_undo")
		set undodir=~/.vim/undodir/
		set undofile
endif

" Map <c-s> to save current buffer
nmap <silent> <M-s> :update<cr>
nmap <leader>s :update<cr>

" FIXME: does not work :(
" autocmd QuickfixCmdPre :copen<CR>
autocmd FileType qf set norelativenumber

" Add vim-umimpair style option switching
" TODO: toggle auto search highlighting

" FIXME: Setting seems to get lost after some time during a long vim session
set history=5000

" Removes trailing spaces
command! TrimWhiteSpace call TrimWhiteSpace()
function! TrimWhiteSpace()
        %s/\s*$//
endfunction

" Display tabs and trailing whitespace
set listchars=tab:\|\ ,trail:+,extends:>,precedes:<,nbsp:.
" FIXME: the following setting gives very slow rendering
" set listchars=tab:‣\ ,trail:□,extends:↦,precedes:↤,nbsp:∙
set nolist
highlight SpecialKey ctermfg=DarkRed ctermbg=NONE
highlight NonText ctermfg=DarkGreen ctermbg=NONE

" Rename current file in split explorer
map <leader>r :let @f=expand("%:p:t")<cr>:Sexplore<cr>/<c-r>f<cr>R

" Open file with default action
nmap <leader>o :silent !open "%"<cr>

" Quick window resizing
map <leader>+ 20<c-w><
map <leader>_ 15<c-w>>

let g:pyclewn_terminal = "xterm, -e"
let g:pyclewn_python = "/opt/local/bin/python3.3"
let g:pyclewn_args="--file=/tmp/pyclewn.log --window=top"
nmap <leader>D :Pyclewn pdb %
nmap <F8> :exe "Cprint " . expand("<cword>") <CR>

autocmd BufRead *.jar,*.apk,*.war,*.ear,*.sar,*.rar set filetype=zip

nmap Q :qall<cr>
