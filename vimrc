" vim: foldmethod=marker path=~/.vim/plugged isf-=/ foldcolumn=3
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
let g:fzf_command_prefix = 'Fzf'
nnoremap U <c-r>
nmap <c-r> :FzfHistory:<cr>
nmap <c-e> :FzfHistory/<cr>
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

map <leader>T :FzfTags<cr>
map <leader>M :FzfMarks<cr>
map <leader>h :tabnew<cr>:FzfHelptags<cr>:only<cr>
map <leader>lC :FzfBCommits<cr>
map <leader>ll :FzfBLines<cr>
map <leader>la :FzfAg<cr>
map <leader>b :FzfBuffers<cr>
map <leader>lc :FzfCommits<cr>
map <leader>lf :FzfFiles<cr>
map <leader>lL :FzfLines<cr>
map <leader>lt :FzfFiletypes<cr>
map <leader>w :FzfWindows<cr>
" }}}
" Git {{{
Plug 'tpope/vim-fugitive'
nmap <leader>gd :Gvdiff<cr>
nmap <leader>gc :Gcommit --verbose<cr>
nmap <leader>gC :Gcommit --verbose --amend<cr>
nmap <leader>gs :tabnew<cr>:Gstatus<cr>
nmap <leader>gb :Gblame<cr>
nmap <leader>gl :silent! Glog --<cr>:bot copen<cr>
autocmd FileType gitcommit map <buffer> ; odvjlzi
autocmd FileType gitcommit map <buffer> pp :Gpull<cr>
autocmd FileType gitcommit map <buffer> P :Gpush<cr>
autocmd FileType gitcommit map <buffer> C :Gcommit\ --verbose<cr>
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
Plug 'Ilink/cscope-quickfix'
set cscopepathcomp=2
" set cscopeprg=/opt/local/bin/cscope
set cscopetag
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscoperelative
" nnoremap <C-n> :lnext<cr>
function! QfLlNext()
    windo if &l:buftype == "quickfix" | silent! cnext | if &l:buftype == "location" | silent! lnext | endif | endif
endfunction
function! QfLlPrevious()
    windo if &l:buftype == "quickfix" | silent! cprevious | if &l:buftype == "location" | silent! lprevious | endif | endif
endfunction
nnoremap <C-n> :call QfLlNext()<cr>
nnoremap <C-p> :call QfLlPrevious()<cr>
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
Plug 'gcmt/taboo.vim' "{{{
let g:taboo_tab_format = "[%N|%f%m(%W)] "
" let g:taboo_tab_format = "[%N|%a/%f%m(%W)] "
let g:taboo_renamed_tab_format ="[%N|%l%m(%W)] "
nmap <leader>tR :TabooReset<cr>
nmap <leader>tr :TabooRename 
nmap <leader>to :TabooOpen 
nmap <leader>, gT
nmap <leader>. gt
map <c-1> gT
map <c-2> gt
nmap <leader>N :tabnew<cr>
nmap <leader>tn :$tabnew<cr>
nmap <leader>tc :tabclose<cr>
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
let g:pandoc#folding#level = 9
" let g:pandoc#formatting#mode = 'hA' " hard wraps, auto smart
let g:pandoc#formatting#mode = 'h' " soft wraps 
" let g:pandoc#formatting#mode = 's' " soft wraps 
" let g:pandoc#formatting#mode = 'a' " autoformatting
" let g:pandoc#formatting#mode = 'A' " smart autoformatting (watch out for source code)
let g:pandoc#formatting#textwidth=79
let g:pandoc#modules#disabled = ["chdir"]
let g:pandoc#formatting#extra_equalprg="--atx-headers"
" let g:pandoc#formatting#equalprg= "pandoc -t markdown --atx-headers --columns " . g:pandoc#formatting#textwidth
let g:pandoc#formatting#smart_autoformat_on_cursormoved = 0

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
" autocmd FileType json set conceallevel=0
let g:vim_json_syntax_concealcursor = 0
" }}}
" NERD Tree {{{
Plug 'scrooloose/nerdtree'
let NERDTreeIgnore=['\~$[[file]]', '\.pyc$[[file]]']
let NERDTreeShowHidden=1
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
command! OpenBrowserCurrent execute "OpenBrowser" "file://" . expand('%:p:gs?\\?/?')
map gX OpenBrowserCurrent
" let g:openbrowser_browser_commands = [
"         \   {'name': 'google-chome',
"         \    'args': ['start', '{browser}', '{uri}']}
"         \]

Plug 'rhysd/open-pdf.vim'
let g:pdf_convert_on_edit = 1
let g:pdf_convert_on_read = 1
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
let g:ale_open_list = 0
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
map <leader>tt :TagbarToggle<cr>
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
Plug 'Lokaltog/vim-distinguished'
" }}}

Plug 'tomasr/molokai'
Plug 'Valloric/vim-operator-highlight'
" Plug 'mileszs/ack.vim'
" let g:ackhighlight = 1
" let g:ack_autofold_results = 0
" let g:ackpreview = 0
" let g:ack_use_dispatch = 1
" map <leader>a :Ack! \\b<cword\\b><CR>
Plug 'brookhong/ag.vim'

" }}}
Plug 'brookhong/ag.vim' "{{{
map <leader>a :Ag! \\b<cword\\b><CR>
"}}}
Plug 'bling/vim-airline' "{{{
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_detect_modified=1
let g:airline_detect_spelllang=1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" let g:airline_theme='raven'
let g:airline_theme='qwq'
" }}}
" Dispatch {{{
Plug 'tpope/vim-dispatch'
" map <leader>M :update<cr>:Make<cr>:copen<cr>/error:<cr>n
map <leader>m :update<cr>:Make<cr>
map <leader>R :source ~/.vimrc<cr>
" }}}

Plug 'sickill/vim-pasta'
let g:pasta_disabled_filetypes = ['python', 'coffee', 'yaml', 'tagbar']
Plug 'dsh2/vim-unimpaired'
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

Plug 'dsh2/vim-man'

Plug 'ervandew/matchem'
Plug 'tpope/vim-dadbod'

Plug 'francoiscabrol/ranger.vim'

Plug 'maksimr/vim-yate'
Plug 'lzap/vim-selinux'
Plug 'vim-scripts/VCard-syntax'
Plug 'Chiel92/vim-autoformat'
let g:autoformat_verbosemode=0
map <leader>A :Autoformat<cr>
Plug 'wannesm/wmgraphviz.vim'
Plug 'tpope/vim-commentary'
autocmd FileType sshconfig setlocal commentstring=#\ %s
autocmd FileType sshdconfig setlocal commentstring=#\ %s
autocmd FileType shell setlocal commentstring=#\ %s
autocmd FileType shell setlocal commentstring=#\ %s
autocmd FileType i3config setlocal commentstring=#\ %s

Plug 'mboughaba/i3config.vim'
Plug 'fatih/vim-go'
map gD :GoDocBrowser<cr>

Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'dsh2/diff-fold.vim'
Plug 'idanarye/vim-merginal'
map <leader>y :MerginalToggle<cr>

" Plug 'MarcWeber/vim-addon-qf-layout'
Plug 'skywind3000/asyncrun.vim'
map <leader>B :AsyncRun binwalk %<cr>
augroup vimrc
    autocmd User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
    nnoremap <buffer> <silent> <cr> 0f/lgf
augroup END

" Plug 'justinmk/vim-sneak'
" map S <Plug>Sneak_s

" TODO: Make this work
Plug 'flatcap/vim-keyword'
map <leader>k <plug>KeywordToggle\|:set nohlsearch<cr>
map <leader>K :call keyword#KeywordClear()<cr>
let g:keyword_group = 'keyword_group'
let g:keyword_highlight = 'ctermbg=red cterm=underline'

call plug#end()
" }}}
" Global options {{{
" colorscheme seoul256
map <leader>n :colorscheme Tomorrow-Night<cr>
colorscheme Tomorrow-Night
" colorscheme solarized

" set verbose=1
" let &viminfo="'50,<1000,s100,:9999,/9999,n~/.vim/viminfo/" . substitute($PWD, "/\| ", "_", "g")
let &viminfo="'50,<1000,s100,:9999,/9999,n~/.vim/viminfo/" . substitute(substitute($PWD, "/", "_", "g"), " ", "_", "g")
set autoindent
set autowrite
set backspace=indent,eol,start
set backupdir=~/.vim/backup/
set cmdheight=1
set cmdwinheight=10
set complete+=k
set concealcursor=n
set conceallevel=0
set diffopt=
" set diffopt=filler,context:4
set dir=~/.vim/swo
set encoding=utf8
set exrc
set foldlevelstart=99
" set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldopen=hor,mark,percent,quickfix,tag
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
set dictionary+=/usr/share/dict/american-english
set smartcase
set smartindent
set smarttab
set statusline=%<%f%h%m%r%=%b\ 0x%B\ \ %l,%c%V\ %P
set tabstop=8
set title
set titleold=''
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
set ttimeoutlen=50
set undodir=~/.vim/undodir/
set undofile
set updatetime=500
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
nnoremap <C-W>m <C-W>\| <C-W>_
nnoremap <C-W>M <C-W>=
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

" Add support for reading manual pages
runtime! ftplugin/man.vim
autocmd FileType man set sidescrolloff=0
set keywordprg=:Man
nmap K :exe "Vman " . expand("<cword>") <CR>
let g:ft_man_open_mode = 'vert'
let g:ft_man_folding_enable = 1

" Make 'K' lookup vim help for vim files
autocmd FileType vim nmap  K :exe "help " . expand("<cword>")<CR>
autocmd FileType vim setl keywordprg=help
autocmd FileType help set nonumber
autocmd FileType help set sidescrolloff=0
autocmd FileType help wincmd L
" autocmd FileType help wincmd L | vert resize 80

" Add a cursorline(/cursorcolumn) to the active window
" autocmd BufWinLeave * set nocursorline |
" 	    \ highlight CursorLineNr ctermbg=grey

autocmd BufWinEnter * set cursorline |
	    \ highlight CursorLineNr ctermfg=white |
	    \ highlight CursorLineNr ctermbg=red |
	    \ highlight CursorLine cterm=underline
set cursorline
set cursorcolumn

nnoremap <cr> :nohlsearch<CR>/<BS><CR>

" Enable spell checking for commit messages
autocmd BufReadPost /tmp/cvs*,svn-commit.tmp*,*hg-editor* setl spell
autocmd BufNewFile,BufReadPost *.git/COMMIT_EDITMSG setf gitcommit | set spell

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
command! -nargs=0 Messages call <SID>Redir("messages")

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
set diffopt=filler
" set diffopt=filler,context:4

" au BufEnter,BufNew,OptionSet * if &diff | let g:solarized_diffmode="normal" | colorscheme solarized | set diffopt= | else | colorscheme Tomorrow-Night | endif

imap <NUL> <space>h
nmap gF :tabedit <cfile><cr>

au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])

map <c-w>v <c-w>v<c-w>l

hi SpellBad ctermbg=none ctermfg=red cterm=undercurl
nmap zz ]seas
nmap zZ :spellr<cr>
set lazyredraw
au BufRead *.md if expand("%:p") =~ '.*/Notizen/.*' | echo "spell german" | setl spelllang="de_20" | else | echo "NO german" | endif

vmap DP :diffput<cr>
vmap DG :diffget<cr>
vmap Gv :GV!<cr>
vmap GV :GV?<cr>

if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
		\	if &omnifunc == "" |
		\		setlocal omnifunc=syntaxcomplete#Complete |
		\	endif
endif

" }}}
" }}}
