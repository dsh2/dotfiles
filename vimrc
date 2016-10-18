let mapleader = "\<Space>"
" Setup Vundle.vim
set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/Vundle.vim

" Begin of setup Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

Plugin 'sukima/xmledit'
Plugin 'christoomey/vim-sort-motion'

" Git stuff
Plugin 'tpope/vim-fugitive'
nmap <leader>gd :Gvdiff<cr>
nmap <leader>gc :Gcommit --verbose<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gv :Gblame<cr>
nmap <leader>gl :silent! Glog --<cr>:bot copen<cr>
Plugin 'junegunn/gv.vim'
nmap <leader>gv :GV<cr>

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
nnoremap U <c-r>
nmap <c-r> :History:<cr>
nmap <c-e> :History/<cr>

Plugin 'will133/vim-dirdiff'
let g:DirDiffExcludes = "*.class,*.exe,.*.swp,*.so,*.img"
Plugin 'rickhowe/diffchar.vim'
let g:DiffUnit = 'Char'

Plugin 'chrisbra/Recover.vim'
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black

" Cscope
Plugin 'vim-scripts/cscope-quickfix'
set cscopepathcomp=2
set cscopeprg=/opt/local/bin/cscope
set cscopetag
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscoperelative
nnoremap <C-n> :cn<cr>
nnoremap <C-p> :cp<cr>
Plugin 'hari-rangarajan/CCTree' 
let g:CCTreeDisplayMode=1
let g:CCTreeHilightCallTree=1
Plugin 'sk1418/QFGrep'

" Utils
Plugin 'Shougo/vimproc.vim'
Plugin 'vim-scripts/genutils'
Plugin 'vim-scripts/multiselect'
Plugin 'vim-scripts/SelectBuf'
nmap <silent><M-F3> :Buffers<cr>
nmap <silent> <F3> <Plug>SelectBuf
let g:selBufDoFileOnClose=0

Plugin 'tpope/vim-unimpaired'
Plugin 'embear/vim-foldsearch'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rsi'
Plugin 'tpope/vim-eunuch'
Plugin 'tpope/vim-tbone'
Plugin 'kana/vim-fakeclip'
let g:fakeclip_terminal_multiplexer_type = "tmux"
Plugin 'dkprice/vim-easygrep'
Plugin 'nelstrom/vim-visual-star-search'

Plugin 'junegunn/vim-peekaboo'
let g:peekaboo_window = 'vertical botright 51new'
let g:peekaboo_delay = 100
let g:peekaboo_compact = 0

Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax' 
let g:pandoc#folding#level=0

Plugin 'junegunn/rainbow_parentheses.vim'
Plugin 'jiangmiao/auto-pairs'

Plugin 'tyru/open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
command! OpenBrowserCurrent execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')
nmap gX OpenBrowserCurrent

Plugin 'vim-scripts/Tail-Bundle'
Plugin 'vim-scripts/httplog'
Plugin 'edsono/vim-matchit'
Plugin 'vim-scripts/renamer.vim'
Plugin 'tmux-plugins/vim-tmux'
autocmd BufRead,BufNewFile tmux.conf set filetype=tmux

" Lua
Plugin 'xolox/vim-lua-ftplugin'
" Plugin 'xolox/vim-easytags'
Plugin 'xolox/vim-misc'

Plugin 'tpope/vim-afterimage'
" json
Plugin 'elzr/vim-json'
"function! FormatJSON()
		":'<,'>!python -m json.tool
"endfunction
"map =j :call FormatJSON()<cr>

" NERD Tree
Plugin 'scrooloose/nerdtree'
let NERDTreeIgnore=['\~$[file]', '\.pyc$[file]']
let NERDTreeWinSize=35
autocmd FileType nerdtree map <buffer> l oj^
"autocmd FileType nerdtree map <buffer> O mo
autocmd FileType nerdtree map <buffer> h x^
autocmd FileType nerdtree map <buffer> ; go
autocmd FileType nerdtree map <buffer> <F2> :NERDTreeClose<cr>
nnoremap <F2> :NERDTreeFind<cr>
Plugin 'Xuyuanp/nerdtree-git-plugin'

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

Plugin 'maksimr/vim-yate'
Plugin 'lzap/vim-selinux'
Plugin 'tpope/vim-dispatch'
map <leader>M :update<cr>:Make<cr>:copen<cr>/error:<cr>n
map <leader>R :source ~/.vimrc<cr>

" Vim-airline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#ctrlp#color_template = 'visual'
let g:airline#extensions#ctrlp#show_adjacent_modes = 0
let g:airline#extensions#whitespace#enabled = 0

" Folding
" Plugin 'tmhedberg/SimpylFold'
" let g:SimpylFold_docstring_preview=1

let g:autoswap_detect_tmux = 1
Plugin 'gioele/vim-autoswap'

" Colorschemes
"Plugin 'govindkrjoshi/CSApprox'
"Plugin 'KevinGoodsell/vim-csexact'
Plugin 'altercation/vim-colors-solarized'
Plugin 'jnurmine/Zenburn'
Plugin 'junegunn/seoul256.vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'reedes/vim-colors-pencil'

syntax enable
colorscheme default
nmap S :colorscheme solarized<cr>
set background=dark

Plugin 'vim-scripts/VCard-syntax'
Plugin 'Chiel92/vim-autoformat'

" Comma separated values
Plugin 'chrisbra/csv.vim'
" hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
" hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
" hi link CSVColumnOdd MoreMsg
" hi link CSVColumnEven Question
" autocmd Filetype csv hi CSVColumnEven ctermbg=4
" autocmd Filetype csv hi CSVColumnOdd  ctermbg=5
let g:csv_no_column_highlight = 0
let b:csv_arrange_align = 'llllllll'
let g:csv_autocmd_arrange      = 1
map <leader>C :setlocal modifiable<cr>:setlocal filetype=csv<cr>

" Undotree
Plugin 'mbbill/undotree'
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1

Plugin 'tpope/vim-commentary'
Plugin 'wannesm/wmgraphviz.vim'

Plugin 'hsanson/vim-android'
let g:android_sdk_path = $ANDROID_SDK_ROOT
let g:android_airline_android_glyph = 'U+f17b'
"Plugin 'artur-shaik/vim-javacomplete2'

Plugin 'idanarye/vim-vebugger'
let g:vebugger_leader='<Leader>d'
let g:vebugger_path_gdb='ggdb'

"Plugin 'alderz/smali-vim'
Plugin 'kelwin/vim-smali'

call vundle#end()
filetype plugin indent on
" End of setup Vundle.vim

" Options
set autoindent
set autowrite
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
set norelativenumber
set ruler
set shiftwidth=4
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
set titleold=''
set updatetime=500
set wildignore=*~,*.o,*.obj,*.aux
set wildmenu
set wildmode=list:longest,full
set winminheight=0

" Make 'K' lookup vim help for vim files
autocmd FileType vim nmap  K :exe "help " . expand("<cword>") <CR>
nmap  <buffer>K :exe "Man " . expand("<cword>") <CR>
let g:ft_man_folding_enable = 0
autocmd FileType vim setl keywordprg=help
autocmd FileType help set nonumber
autocmd FileType help set sidescrolloff=0
autocmd FileType help wincmd L
"autocmd FileType help wincmd L | vert resize 80

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
autocmd BufWinLeave * set nocursorline |
		\ highlight CursorLineNr ctermbg=grey

autocmd BufWinEnter * set cursorline |
		\ highlight CursorLineNr ctermfg=white |
		\ highlight CursorLineNr ctermbg=red |
		\ highlight CursorLine cterm=underline
set cursorline

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

" Save current buffer
nmap <silent> <F9> :update<cr>
nmap <silent> <A-s> :update<cr>
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

command! -nargs=1 Redir call <SID>Redir(<f-args>)

function! s:Redir(cmd) abort
	let l:oldz = @z
	redir @z
	silent! exe a:cmd
	redir END
	new
	silent! put z
	let @z = l:oldz
	" Remove blank lines and superfluous greater-than symbol (silently)
	silent! %g/^[\s>]*$/d
	" Make the buffer not related to any sort of file, and will never be written
	set buftype=nofile
endfunction
map  
map <leader><c-l> :redraw!<cr>

function! MarkWindowSwap()
    let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
	"Mark destination
	let curNum = winnr()
	let curBuf = bufnr( "%" )
	exe g:markedWinNum . "wincmd w"
	"Switch to source and shuffle dest->source
	let markedBuf = bufnr( "%" )
	"Hide and open so that we aren't prompted and keep history
	exe 'hide buf' curBuf
	"Switch to dest and shuffle source->dest
	exe curNum . "wincmd w"
	"Hide and open so that we aren't prompted and keep history
	exe 'hide buf' markedBuf 
endfunction
nmap <silent> <leader>mw :call MarkWindowSwap()<CR>
nmap <silent> <leader>pw :call DoWindowSwap()<CR>

map <leader>la :Ag<cr>
map <leader>lf :Files<cr>
map <leader>lt :Filetypes<cr>
map <leader>ll :Lines<cr>
map <leader>lL :BLines<cr>
map <leader>lc :Commits<cr>
map <leader>lC :BCommits<cr>
map <leader>lb :Buffers<cr>
map <leader>TT :Tags<cr>
