" vim: set foldmethod=marker foldlevel=0:
" .vimrc of dsh2 {{{
let mapleader = "\<Space>""
" Plugins {{{
set nocompatible
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
call plug#begin('~/.vim/plugged')
" Unite {{{
Plug 'Shougo/unite.vim'
nnoremap <silent> <leader>lb :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> <F3> :Unite buffer<cr>

Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neomru.vim'
let g:neomru#time_format='%F %T '
let g:neomru#update_interval=60

autocmd FileType vimfiler map <buffer> ; go
autocmd FileType vimfiler map <buffer> <c-l> <tab>
autocmd FileType vimfiler map <buffer> gi <Plug>(vimfiler_toggle_visible_ignore_files)
autocmd FileType vimfiler nmap <buffer> i :VimFilerPrompt<CR>
let g:vimfiler_as_default_explorer = 0
let g:vimfiler_define_wrapper_commands = 1
let g:vimfiler_expand_jump_to_first_child = 0
let g:vimfiler_no_default_key_mappings = 0
let g:vimfiler_quick_look_command = 'gloobus-preview'
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_time_format = "%Y-%m-%d %H:%M:%S"
nnoremap <F5> :VimFilerDouble -find<cr>
Plug 'Shougo/vimfiler.vim'
Plug 'romgrk/vimfiler-prompt'
" }}}
" FZF! {{{
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
let g:fzf_prefer_tmux = 0
nnoremap U <c-r>
nmap <c-r> :History:<cr>
nmap <c-e> :History/<cr>
let g:fzf_tags_command = 'ctags -R'
command! Colors call fzf#vim#colors({'right': '15%', 'options': '--reverse --height=100%'})
command! -bang -nargs=* Ag
	    \ call fzf#vim#ag(<q-args>,
	    \                 <bang>0 ? fzf#vim#with_preview('up:60%')
	    \                         : fzf#vim#with_preview('right:50%'),
	    \                 <bang>0)
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
let g:fzf_layout = { 'down': '~70:%' }
imap <c-x><c-h> <plug>(fzf-complete-path)
" inoremap <expr> <c-x><c-k> fzf#complete('cat /usr/share/dict/words')

map <leader>T :Tags<cr>
map <leader>M :Marks<cr>
map <leader>H :Helptags<cr>
map <leader>h :Helptags<cr>
map <leader>lC :BCommits<cr>
map <leader>ll :BLines<cr>
map <leader>la :Ag<cr>
map <leader>b :Buffers<cr>
map <leader>lc :Commits<cr>
map <leader>lf :Files<cr>
map <leader>lL :Lines<cr>
map <leader>lt :Filetypes<cr>
map <leader>w :Windows<cr>
" }}}
" Git {{{
Plug 'tpope/vim-fugitive'
nmap <leader>gd :Gvdiff<cr>
nmap <leader>gc :Gcommit --verbose<cr>
nmap <leader>gs :Gstatus<cr>
nmap <leader>gb :Gblame<cr>
nmap <leader>gl :silent! Glog --<cr>:bot copen<cr>
Plug 'junegunn/gv.vim'
nmap <leader>gv :GV<cr>
nmap <leader>gV :GV!<cr>
autocmd FileType GV map <buffer> ; o
autocmd FileType GV map <buffer> l ;
autocmd FileType GV map <buffer>  O

Plug 'airblade/vim-gitgutter'
let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black
" }}}
" DirDiff {{{
Plug 'will133/vim-dirdiff'
let g:DirDiffExcludes = "*.class,*.exe,.*.swp,*.so,*.img"
" Plug 'rickhowe/diffchar.vim'
let g:DiffUnit = 'Word1'
" }}}
" cscope {{{
" Plug 'vim-scripts/cscope-quickfix'
Plug 'Ilink//cscope-quickfix'
set cscopepathcomp=2
" set cscopeprg=/opt/local/bin/cscope
set cscopetag
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscoperelative
nnoremap <C-n> :cn<cr>
nnoremap <C-p> :cp<cr>
Plug 'hari-rangarajan/CCTree'
let g:CCTreeDisplayMode=1
let g:CCTreeHilightCallTree=1
Plug 'sk1418/QFGrep'
" }}}
" {{{ Completor
" Plug 'maralla/completor.vim'

" }}}

" YouCompleteMe {{{
" function! BuildYCM(info)
"   if a:info.status == 'installed' || a:info.force
"     !./install.py
"   endif
" endfunction
" let g:loaded_youcompleteme = 0
" Plug 'Valloric/YouCompleteMe', { 'do': function('BuildYCM') }
" let g:ycm_autoclose_preview_window_after_insertion = 1
" nnoremap <leader>jj :YcmCompleter GoTo<CR>
" nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
" nnoremap <leader>jD :YcmCompleter GoToDeclaration<CR>
" nnoremap <leader>jr :YcmCompleter GoToReferences<CR>
" nnoremap <leader>jt :YcmCompleter GetType<CR>
" nnoremap <leader>jk :YcmCompleter GetDoc<CR>
" let g:ycm_error_symbol="E>"
" let g:yvm_warning_symbol="W>"
" let g:ycm_enable_diagnostic_highlighting=1
" let g:ycm_collect_identifiers_from_comments_and_strings=1
" let g:ycm_collect_identifiers_from_tags_files=1
" }}}
" Text objects {{{
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-fold'
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-lastpat'
Plug 'vim-scripts/argtextobj.vim'
Plug 'vim-utils/vim-space'
" }}}
" github dashboard {{{
Plug 'junegunn/vim-github-dashboard'
let g:github_dashboard = { 'username': 'dsh2', 'password': $GHD_GITHUB_TOKEN }
" }}}
" Taboo {{{
Plug 'gcmt/taboo.vim'
let g:taboo_tab_format = " %N|%P%f%m%U "
let g:taboo_renamed_tab_format =" %N|%l%m%U "
nmap <leader>, gT
nmap <leader>. gt
nmap <leader>N :tabnew<cr>
" }}}
" ToggleList {{{
Plug 'milkypostman/vim-togglelist'
nmap <silent> <leader><c-j> :colder<CR>
nmap <silent> <leader><c-k> :cnewer<CR>
nmap <silent> <leader>O :copen<CR>
" }}}
" General edit help {{{
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'Konfekt/vim-CtrlXA'
" }}}
" Undotree {{{
Plug 'mbbill/undotree'
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1
" let g:undotree_DiffCommand = "diff -y"
let g:undotree_DiffCommand = "diff -U 5"
let g:undotree_DiffpanelHeight = 25
let g:undotree_TreeNodeShape = "o"
nnoremap <F4> :UndotreeToggle<cr>
" }}}
" pandoc {{{
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
let g:pandoc#folding#level=0
" hi Folded ctermbg=bg ctermfg=fg cterm=NONE
hi Folded cterm=NONE
" }}}
" Comma separated values {{{
Plug 'chrisbra/csv.vim'
" hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
" hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
" hi link CSVColumnOdd MoreMsg
" hi link CSVColumnEven Question
" autocmd Filetype csv hi CSVColumnEven ctermbg=4
" autocmd Filetype csv hi CSVColumnOdd  ctermbg=5
let g:csv_no_column_highlight = 0
let b:csv_arrange_align = 'l*'
let g:csv_arrange_align = 'l*'
let g:csv_autocmd_arrange = 1
" map <leader>C :setlocal modifiable<cr>:setlocal filetype=csv<cr>ggVG:ArrangeColumn!<cr>let b:csv_headerline = 0<cr>
map <leader>C :setlocal modifiable<cr>:setlocal filetype=csv<cr>ggVG:ArrangeColumn!<cr>let g:csv_headerline = 0<cr>
autocmd BufRead,BufNewFile *.csv set filetype=csv
" }}}
" vim-android {{{
" Plug 'hsanson/vim-android'
let g:android_sdk_path = $ANDROID_SDK_ROOT
let g:android_airline_android_glyph = 'U+f17b'
"Plug 'artur-shaik/vim-javacomplete2'
" }}}
" Smali {{{
"Plug 'alderz/smali-vim'
Plug 'kelwin/vim-smali'
autocmd BufRead *.smali set filetype=smali
" }}}
" Lua {{{
Plug 'xolox/vim-lua-ftplugin'
Plug 'xolox/vim-misc'
" }}}
" Python {{{
Plug 'vim-scripts/indentpython.vim'
" Plug 'nvie/vim-flake8'
" Plug 'davidhalter/jedi-vim'
" let g:jedi#use_splits_not_buffers = "right"
" }}}
" json {{{
Plug 'elzr/vim-json'
" }}}
" NERD Tree {{{
Plug 'scrooloose/nerdtree'
let NERDTreeIgnore=['\~$[[file]]', '\.pyc$[[file]]']
let NERDTreeWinSize=40
autocmd FileType nerdtree map <buffer> l oj^
"autocmd FileType nerdtree map <buffer> O mo
autocmd FileType nerdtree map <buffer> h x^
autocmd FileType nerdtree map <buffer> ; go
autocmd FileType nerdtree map <buffer> <F2> :NERDTreeClose<cr>
nnoremap <F2> :NERDTreeFind<cr>
Plug 'Xuyuanp/nerdtree-git-plugin'
" }}}
" OpenBrowser {{{
Plug 'tyru/open-browser.vim'
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
command! OpenBrowserCurrent execute "OpenBrowser" "file:///" . expand('%:p:gs?\\?/?')
nmap gX OpenBrowserCurrent
" }}}
" Syntastic {{{
" Plug 'scrooloose/syntastic'
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 0
" let g:syntastic_check_on_open = 0
" let g:syntastic_check_on_wq = 0
" let g:syntastic_lua_checkers = ["luac", "luacheck"]
" let g:syntastic_lua_luacheck_args = "--no-unused-args"
" let g:syntastic_go_checkers = ['golint', 'govet', 'gometalinter']
" let g:syntastic_go_gometalinter_args = ['--disable-all', '--enable=errcheck']
" let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
" let g:go_list_type = "quickfix"
" " }}}
" {{{ ALE - Asynchronous Lint Engine
Plug 'w0rp/ale'
let g:airline#extensions#ale#enabled = 1
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_keep_list_window_open = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 0
let g:ale_lint_on_text_changed = "never"
" taglist/tagbar {{{
" Plug 'vim-scripts/taglist.vim'
" let Tlist_Use_Right_Window = 1
" let Tlist_WinWidth = 55
" let Tlist_Display_Prototype = 1
" let Tlist_Exit_OnlyWindow = 1
" let Tlist_GainFocus_On_ToggleOpen = 0
" let Tlist_Highlight_Tag_On_BufEnter = 1
" let Tlist_Auto_Open = 1
" let Tlist_Show_One_File = 1
" map <leader>t :TlistToggle<cr>
Plug 'majutsushi/tagbar'
let g:tagbar_autoclose = 0
let g:tagbar_width = 50
let g:tagbar_zoomwidth = 0
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_show_linenumbers = 0
let g:tagbar_autofocus = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_autopreview = 0

let g:tagbar_type_go = {
	    \ 'ctagstype' : 'go',
	    \ 'kinds'     : [
	    \ 'p:package',
	    \ 'i:imports:1',
	    \ 'c:constants',
	    \ 'v:variables',
	    \ 't:types',
	    \ 'n:interfaces',
	    \ 'w:fields',
	    \ 'e:embedded',
	    \ 'm:methods',
	    \ 'r:constructor',
	    \ 'f:functions'
	    \ ],
	    \ 'sro' : '.',
	    \ 'kind2scope' : {
	    \ 't' : 'ctype',
	    \ 'n' : 'ntype'
	    \ },
	    \ 'scope2kind' : {
	    \ 'ctype' : 't',
	    \ 'ntype' : 'n'
	    \ },
	    \ 'ctagsbin'  : 'gotags',
	    \ 'ctagsargs' : '-sort -silent'
	    \ }
autocmd VimEnter * nested :call tagbar#autoopen(1)
map <leader>t :TagbarToggle<cr>
autocmd FileType tagbar map <buffer> ; p
autocmd FileType tagbar map <buffer> l za
autocmd FileType tagbar map <buffer> h za
" }}}
" Markology {{{
Plug 'jeetsukumaran/vim-markology'
let g:markology_enable = 0
let g:markology_textlower = "\t>"
let g:markology_textupper = "\t}"
let g:markology_textother = "\t:"
let g:markology_hlline_lower = 0
let g:markology_hlline_upper = 0
let g:markology_hlline_other = 0
highlight MarkologyHLl ctermfg=Cyan ctermbg=black
highlight MarkologyHLu ctermfg=Cyan ctermbg=black
highlight MarkologyHLo ctermfg=Cyan ctermbg=black
" }}}
" HighlightsWords {{{
Plug 'ihacklog/HiCursorWords'
let g:HiCursorWords_delay = 10
let g:HiCursorWords_hiGroupRegexp = ''
let g:HiCursorWords_debugEchoHiName = 0
" }}}
" Colorschema {{{
Plug 'xolox/vim-colorscheme-switcher'
nmap <F6> :NextColorScheme<CR>
"Plug 'govindkrjoshi/CSApprox'
"Plug 'KevinGoodsell/vim-csexact'
" Plug 'AlessandroYorba/Monrovia'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'jnurmine/Zenburn'
Plug 'junegunn/seoul256.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'pwntester/VimCobaltColourScheme'
Plug 'pwntester/cobalt2.vim'
Plug 'reedes/vim-colors-pencil'
Plug 'chriskempson/base16-vim'
" }}}

Plug 'tomasr/molokai'
Plug 'Valloric/vim-operator-highlight'
Plug 'mileszs/ack.vim'
let g:ackhighlight = 1
let g:ack_autofold_results = 0
let g:ackpreview = 0
let g:ack_use_dispatch = 1
map <leader>a :Ack! \\b<cword\\b><CR>

" }}}
" VimAirline {{{
Plug 'bling/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
" let g:airline_theme='raven'
let g:airline_theme='dark'
" }}}
" Dispatch {{{
Plug 'tpope/vim-dispatch'
" map <leader>M :update<cr>:Make<cr>:copen<cr>/error:<cr>n
map <leader>m :update<cr>:Make<cr>
map <leader>R :update<cr>:source ~/.vimrc<cr>
" }}}

Plug 'sickill/vim-pasta'
let g:pasta_disabled_filetypes = ['python', 'coffee', 'yaml', 'tagbar']
Plug 'tpope/vim-unimpaired'
Plug 'embear/vim-foldsearch'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-tbone'
" Plug 'kana/vim-fakeclip'
" let g:fakeclip_terminal_multiplexer_type = "tmux"
Plug 'dkprice/vim-easygrep'
Plug 'nelstrom/vim-visual-star-search'
Plug 'vim-scripts/AnsiEsc.vim'
map <leader>W :AnsiEsc<cr>
" Remove ansi escape sequence
map <leader>Q :%s/\%x1b\[\([0-9]\{1,2\}\(;[0-9]\{1,2\}\)\{0,1\}\)\{0,1\}[m\|K]//<cr>
Plug 'sukima/xmledit'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-system-copy'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/info.vim'
Plug 'romgrk/winteract.vim'
nmap gw :InteractiveWindow<CR>
Plug 'chrisbra/Recover.vim'
Plug 'Shougo/vinarise.vim'
map <leader>V :Vinarise<cr>

Plug 'nathanaelkane/vim-indent-guides'
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

Plug 'junegunn/vim-peekaboo'
let g:peekaboo_window = 'vertical botright 51new'
let g:peekaboo_delay = 0
let g:peekaboo_compact = 0

Plug 'junegunn/rainbow_parentheses.vim'
" Plug 'kana/vim-smartinput'

Plug 'bumaociyuan/vim-matchit'
Plug 'vim-scripts/renamer.vim'
Plug 'tpope/vim-afterimage'

" tmux integration
Plug 'tmux-plugins/vim-tmux'
autocmd BufRead tmux.conf set filetype=tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'wellle/tmux-complete.vim'
let g:tmuxcomplete#trigger = 'omnifunc'

" Plug 'https://github.com/vim-utils/vim-man'

Plug 'maksimr/vim-yate'
Plug 'lzap/vim-selinux'
Plug 'vim-scripts/VCard-syntax'
Plug 'Chiel92/vim-autoformat'
let g:autoformat_verbosemode=1
map <leader>A :Autoformat<cr>
Plug 'wannesm/wmgraphviz.vim'
Plug 'tpope/vim-commentary'
Plug 'fatih/vim-go'
map gD :GoDocBrowser<cr>

Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'inkarkat/diff-fold.vim'
Plug 'idanarye/vim-merginal'
" Plug 'MarcWeber/vim-addon-qf-layout'
Plug 'skywind3000/asyncrun.vim'
map <leader>B :AsyncRun binwalk %<cr>
augroup vimrc
    autocmd User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
augroup END

Plug 'justinmk/vim-sneak'
map S <Plug>Sneak_s

call plug#end()
" }}}
" Global options {{{
" colorscheme seoul256
colorscheme Tomorrow-Night
set autoindent
set autowrite
set backspace=indent,eol,start
set backupdir=~/.vim/backup/
set cmdheight=1
set cmdwinheight=10
set concealcursor=n
set dir=~/.vim/swo
set encoding=utf8
set exrc
set foldlevelstart=99
set foldopen=hor,mark,percent,quickfix,search,tag,undo
set gdefault
set grepprg=grep\ -nH\ $*
set hidden
set history=9999
set hlsearch
set ignorecase
set incsearch
set isfname-==
set laststatus=2
set mouse=a
set mousefocus
set nobackup
set norelativenumber
set nospell
set nowrap
set nowrapscan
set number
set previewheight=14
set ruler
set scrolloff=999
set shellslash
set shiftwidth=4
set shortmess=filnxtToOI
set showbreak=›
set showcmd
set showfulltag
set showmatch
set sidescroll=15
set sidescrolloff=8
set smartcase
set smartindent
set smarttab
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set tabstop=8
set title
set titleold=''
set ttimeoutlen=50
set undodir=~/.vim/undodir/
set undofile
set updatetime=500
let &viminfo="'50,<1000,s100,:9999,/9999,n~/.vim/viminfo/" . substitute($PWD, "/", "_", "g")
" set verbose=1
set wildignore=*~,*.o,*.obj,*.aux
set wildmenu
set wildmode=list:longest,full
syntax enable
" }}}
" Mappings {{{
nmap Q :qall<cr>
map  
map  :bnext<cr>
map <c-.> :bprev<cr>
map <leader><c-L> :redraw!<cr>
nnoremap <C-W>M <C-W>\| <C-W>_
nnoremap <C-W>m <C-W>=

nmap <leader>o :silent !open "%"<cr>

" Split navigations
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

nmap <nowait> <leader>s :update<cr>
" }}}
" Special operations {{{
" Open log files at the bottom of the file
autocmd BufReadPost *.log normal G
autocmd BufReadPost *.log :set filetype=messages
autocmd BufRead,BufNewFile *.strace set filetype=strace

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

" Make 'K' lookup vim help for vim files
nmap K :exe "Man " . expand("<cword>") <CR>
let g:ft_man_open_mode = 'vert'
let g:ft_man_folding_enable = 1
autocmd FileType vim nmap  K :exe "help " . expand("<cword>") <CR>
autocmd FileType vim setl keywordprg=help
set keywordprg=:Man
autocmd FileType help set nonumber
autocmd FileType help set sidescrolloff=0
autocmd FileType help wincmd L
" autocmd FileType help wincmd L | vert resize 80

" Add a cursorline(/cursorcolumn) to the active window
autocmd BufWinLeave * set nocursorline |
	    \ highlight CursorLineNr ctermbg=grey

autocmd BufWinEnter * set cursorline |
	    \ highlight CursorLineNr ctermfg=white |
	    \ highlight CursorLineNr ctermbg=red |
	    \ highlight CursorLine cterm=underline
set cursorline

nnoremap <cr> :nohlsearch<CR>/<BS><CR>


" Enable spell checking for commit messages
autocmd BufReadPost /tmp/cvs*,svn-commit.tmp*,*hg-editor* setl spell
autocmd BufNewFile,BufReadPost *.git/COMMIT_EDITMSG setf gitcommit | set spell

" Add support for reading manual pages
runtime! ftplugin/man.vim
autocmd FileType man set sidescrolloff=0

" FIXME: does not work :(
" autocmd QuickfixCmdPre :copen<CR>
autocmd FileType qf set norelativenumber
autocmd FileType qf wincmd J

" Removes trailing spaces
command! TrimWhiteSpace call TrimWhiteSpace()
function! TrimWhiteSpace()
    %s/\s*$//
endfunction

set listchars=tab:\|\ ,trail:+,extends:>,precedes:<,nbsp:.
" FIXME: the following setting gives very slow rendering
" set listchars=tab:‣\ ,trail:□,extends:↦,precedes:↤,nbsp:∙
set nolist
highlight SpecialKey ctermfg=DarkRed ctermbg=NONE
highlight NonText ctermfg=DarkGreen ctermbg=NONE

autocmd BufRead *.jar,*.apk,*.war,*.ear,*.sar,*.rar set filetype=zip

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

command! -nargs=0 RelaxSearchPattern call <SID>RelaxSearchPattern()
function! s:RelaxSearchPattern() abort
    let @/=substitute(@/, "^\\V", "", "g")
    let @/=substitute(@/, "_", ".*", "g")
    let @/ = inputdialog("@/: ", @/)
endfunction

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

function! EnableAutoWrite()
    exe ":au FocusLost" expand("%") ":update"
endfunction

command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

hi Folded cterm=NONE

" match ErrorMsg '\%80v\+'

inoremap jk <esc>
" noremap dfj :diffget //2<cr>|diffupdate
" noremap dfh :diffget //2<cr>|diffupdate
" noremap dfk :diffget //3<cr>|diffupdate
" noremap dfl :diffget //3<cr>|diffupdate
" noremap dfu :diffupdate<cr>
nmap <leader>DD :diffthis<CR>
nmap <leader>DO :diffoff<CR>
nmap <leader>DS :vertical diffsplit<CR>

imap <NUL> <space>h
" }}}
" }}}
