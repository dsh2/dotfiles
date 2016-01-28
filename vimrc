" Setup Vundle.vim
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/Vundle.vim

" Begin of setup Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Git stuff
Plugin 'tpope/vim-fugitive'
nmap <leader>gd :Gvdiff<cr>
nmap <leader>gc :Gcommit --verbose<cr>

Plugin 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black

" Cscope
Plugin 'chazy/cscope_maps'
Plugin 'vim-scripts/cscope-quickfix'

" Utils
Plugin 'vim-scripts/genutils'
Plugin 'vim-scripts/SelectBuf'
Plugin 'tpope/vim-unimpaired'
Plugin 'embear/vim-foldsearch'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rsi'
Plugin 'tpope/vim-eunuch'
Plugin 'dkprice/vim-easygrep'

" Lua
Plugin 'xolox/vim-lua-ftplugin'
Plugin 'xolox/vim-misc'

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
autocmd FileType nerdtree map <buffer> L O
autocmd FileType nerdtree map <buffer> h x^
autocmd FileType nerdtree map <buffer> ; go

Plugin 'vim-scripts/indentpython.vim'
Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'kien/ctrlp.vim'
let g:ctrlp_prompt_mappings = { 'ToggleMRURelative()': ['<F2>'] }

"Plugin 'Valloric/YouCompleteMe'

" Show tags of current file in separat window
Plugin 'vim-scripts/taglist.vim'

" Highlights words under the cursor
Plugin 'ihacklog/HiCursorWords'
let g:HiCursorWords_delay = 10
let g:HiCursorWords_hiGroupRegexp = ''
let g:HiCursorWords_debugEchoHiName = 0

Plugin 'lzap/vim-selinux'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'tpope/vim-dispatch'

" Vim-airline
Plugin 'bling/vim-airline'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" Folding
" Plugin 'tmhedberg/SimpylFold'
" let g:SimpylFold_docstring_preview=1

" Colorschemes
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'

" Comma separated values
Plugin 'chrisbra/csv.vim'
" hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
" hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
" hi link CSVColumnOdd MoreMsg
" hi link CSVColumnEven Question
let g:csv_no_column_highlight = 0
let b:csv_arrange_align = 'llllllll'
let g:csv_autocmd_arrange      = 1
let g:csv_autocmd_arrange_size = 1024*1024

" Undotree
Plugin 'mbbill/undotree'
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

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
set sidescrolloff=10
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

" Display tabs and trailing whitespace
set nolist
set listchars=tab:·\ ,trail:†
"set listchars+=eol:¶
highlight SpecialKey ctermfg=DarkRed

" Enable syntax highlighting
syntax enable
colorscheme solarized

" Make 'K' lookup vim help for vim files
autocmd FileType vim setl keywordprg=:help
autocmd FileType help set nonumber
autocmd FileType help wincmd L

" Open log files at the bottom of the file
autocmd BufReadPost *.log normal G

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

" Some Emacs-like mapping for command mode
cmap <C-a> <Home>
cmap <C-e> <End>
cmap <C-d> <Del>
cmap <C-f> <Right>
cmap <C-b> <Left>
set cedit=<C-i>

"
" Function key mappings
"

nnoremap <F2> :NERDTreeFind<cr>
nnoremap <S-F2> :NERDTreeToggle<cr>
nnoremap <F4> :UndotreeToggle<cr>
map <F8> :make<cr>

" Split navigations
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

" What does this mapping do?
nnoremap Q =ap

" Enable spell checking for commit messages
autocmd BufReadPost /tmp/cvs*,svn-commit.tmp*,*hg-editor* setl spell
autocmd BufNewFile,BufReadPost *.git/COMMIT_EDITMSG setf gitcommit | set spell

" vimpager settings
let vimpager_passthrough = 0
let vimpager_scrolloff = 5

" Add support for reading manual pages
runtime! ftplugin/man.vim

" Enable persistent undo
if has("persistent_undo")
		set undodir=~/.vim/undodir/
		set undofile
endif

" Map <c-s> to save current buffer
noremap <silent> <C-s>          :update<cr>
vnoremap <silent> <C-s>         <C-c>:update<cr>
inoremap <silent> <C-s>         <C-c>:update<cr>
"
" Python stuff
" PEP8 indentation
autocmd BufNewFile,BufRead *.py
    \ set tabstop=4
    \ set softtabstop=4
    \ set shiftwidth=4
    \ set textwidth=79
    \ set expandtab
    \ set autoindent
    \ set fileformat=unix

au BufNewFile,BufRead *.js, *.html, *.css
    \ set tabstop=2
    \ set softtabstop=2
    \ set shiftwidth=2

" FIXME: does not work :(
" autocmd QuickfixCmdPre :copen<CR>
" Add vim-umimpair style option switching
" TODO: toggle auto search highlighting
" nnoremap cox :set <C-R>=&cursorline && &cursorcolumn ? 'nocursorline nocursorcolumn' : 'cursorline cursorcolumn'<CR><CR>

set history=5000
