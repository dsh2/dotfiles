" Setup Vundle.vim 
set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'vim-scripts/SelectBuf'
Plugin 'vim-scripts/genutils'
Plugin 'L9'
Plugin 'git://git.wincent.com/command-t.git'
call vundle#end()
filetype plugin indent on    
" End of setup Vundle.vim

" Options
set autoindent
set autowrite
set background=light
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
set nospell
set previewheight=14
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
set title
set updatetime=500
set wildignore=*~,*.o,*.obj,*.aux
set wildmenu
set wildmode=list:longest,full
set winminheight=0

syntax on

" Make 'K' lookup vim help for vim files
au FileType vim setl keywordprg=:help

" Open log files at the bottom of the file
autocmd BufReadPost *.log normal G

" Restore last position in file upon opening a file
autocmd BufReadPost * call RestorePosition()
autocmd BufWritePost ~/.vimrc source ~/.vimrc
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


