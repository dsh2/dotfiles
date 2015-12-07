" Setup Vundle.vim
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/Vundle.vim

" Begin of setup Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Git stuff
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black

" Utils
Plugin 'vim-scripts/genutils'
Plugin 'vim-scripts/SelectBuf'
Plugin 'scrooloose/nerdtree'

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
Plugin 'bling/vim-airline'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chrisbra/csv.vim'
hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta

Plugin 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 1
let g:gitgutter_override_sign_column_highlight = 0
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black

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
set dir=~/.vim/swo
set encoding=utf8
set exrc
set gdefault
set grepprg=grep\ -nH\ $*
set hidden
set history=5000
set hlsearch
set ignorecase
set incsearch
set laststatus=2
set mouse=a
set nobackup
set nocompatible
set nowrapscan
set number
set nospell
set previewheight=14
set relativenumber
set ruler
set scrolloff=99999
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
set list
set listchars=tab:·\ ,trail:†
"set listchars+=eol:¶
highlight SpecialKey ctermfg=DarkRed

" Enable syntax highlighting
syntax enable
colorscheme solarized

" Make 'K' lookup vim help for vim files
autocmd FileType vim setl keywordprg=:help

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
au WinLeave * set nocursorline
au WinEnter * set cursorline
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

"
" Function key mappings
"
nnoremap <F4> :UndotreeToggle<cr>
" Some Quickfix mapping
map <F5> \rlog
map <F6> \older
map <F7> \newer

" Some usual IDE mapping
map <F8> :make<cr>

" Some quickfix key mappings
nnoremap <C-n> :cn<cr>
nnoremap <C-p> :cp<cr>
nnoremap <C-l> :cnewer<cr>
nnoremap <C-h> :colder<cr>

" What does this mapping do?
nnoremap Q =ap

" Enable spell checking for commit messages
autocmd BufReadPost /tmp/cvs*,svn-commit.tmp*,*hg-editor* setl spell
autocmd BufNewFile,BufReadPost *.git/COMMIT_EDITMSG setf gitcommit | set spell

" vimpager settings
let vimpager_passthrough = 0
let vimpager_scrolloff = 5

" airline settings
let g:airline_left_sep='|'
let g:airline_right_sep='|'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1

" Add support for reading manual pages
runtime! ftplugin/man.vim

" Enable persistent undo
if has("persistent_undo")
		set undodir=~/.vim/undodir/
		set undofile
endif

