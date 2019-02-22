" vim: foldmethod=marker path=~/.vim/plugged isf-=/ foldcolumn=3 tw=0 ts=8
let mapleader = "\<Space>"
" Plugins {{{
" vim-plug {{{
set nocompatible
augroup vimrc
    autocmd!
augroup END
if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
		\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd vimrc VimEnter * PlugInstall --sync | source $MYVIMRC
endif
autocmd vimrc FileType vim-plug map <buffer> ; o
call plug#begin('~/.vim/plugged')
" }}}
Plug 'junegunn/fzf' "{{{
Plug 'junegunn/fzf.vim'
let g:fzf_prefer_tmux = 0
let g:fzf_command_prefix = 'Fzf'
" TODO
" -make edit of command default (not c-e)
" -add support for Redir
nmap <c-r> :FzfHistory:<cr>
nmap <c-e> :FzfHistory/<cr>
let g:fzf_tags_command = 'ctags -R'
command! Colors call fzf#vim#colors({'right': '15%', 'options': '--reverse --height=100%'})
" TODO: Make BLines/Lines support preview as well.
" command! -bang -nargs=* FzfLines
"		\ call fzf#vim#lines(<q-args>,
"		\                 <bang>0 ? fzf#vim#with_preview('up:60%')
"		\                         : fzf#vim#with_preview('right:50%'),
"		\                 <bang>0)
command! -bang -nargs=* FzfAg
	    \ call fzf#vim#ag(<q-args>,
	    \                 <bang>0 ? fzf#vim#with_preview('up:60%')
	    \                         : fzf#vim#with_preview('right:50%'),
	    \                 <bang>0)
command! -bang -nargs=? -complete=dir Files call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)
let g:fzf_layout = { 'down': '~70:%' }
inoremap <expr> <c-x><c-l> fzf#complete('tmuxwords.rb --all-but-current --scroll 499 --min 5')
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
" imap <c-x><c-L> <plug>(fzf-complete-line)
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
map <leader>T :FzfTags<cr>
map <leader>M :FzfMarks<cr>
map <leader>h :tabnew<cr>:FzfHelptags<cr>:only<cr>
map <leader>la :FzfAg<cr>
map <leader>ll :FzfBLines<cr>
map <leader>lL :FzfLines<cr>
"
nnoremap <silent> <Leader>` :FzfMarks<CR>
function! GetSelected()
    " save reg
    let reg = '"'
    let reg_save = getreg(reg)
    let reg_type = getregtype(reg)
    " yank visually selected text
    silent exe 'norm! gv"'.reg.'y'
    let value = getreg(reg)
    " restore reg
    call setreg(reg, reg_save, reg_type)
    return value
endfunction
vnoremap <leader>ll :<c-u>execute("FzfBLines ") . GetSelected()<cr>
vnoremap <leader>lL :<c-u>execute("FzfLines ") . GetSelected()<cr>
vnoremap <leader>la :<c-u>execute("FzfAg ") . GetSelected()<cr>
" map <leader>b :FzfBuffers<cr>
map <leader>b :FzfHistory<cr>
map <leader>lc :FzfCommits<cr>
map <leader>lC :FzfBCommits<cr>
map <leader>lf :FzfFiles<cr>
map <leader>lt :FzfFiletypes<cr>
map <leader>w :FzfWindows<cr>
" }}}
Plug 'tpope/vim-fugitive' "{{{
" HELP: Find out why the screwed up map works and the other one NOT!
" nmap <leader>gd :Gvdiff<cr><c-w>l
nmap <silent> <leader>gd :TagbarClose<cr>:Gvdiff<cr>:ERROR<cr>:set nofoldendable<cr>:wincmd l<cr>
nmap <leader>gD :Gdelete<cr>:ERROR<cr>:wincmd L<cr>
nmap <leader>gc :tabnew<cr>:Gcommit --verbose<cr>:only<cr>
nmap <leader>gC :tabnew<cr>:Gcommit --verbose --amend<cr>:only<cr>
nmap <leader>gx dp:wincmd h<cr>:update<cr>:wincmd l<cr>
nmap <leader>gs :tabnew<cr>:Gstatus<cr>o
nmap <leader>gb :Gblame<cr>
nmap <leader>gp :Gpush<cr>
nmap <leader>gw :Gwrite<cr>
nmap <leader>gg :Git
nmap <leader>gl :silent! Glog --<cr>:bot copen<cr>
" TODO: Find out why this end up in the left window
autocmd vimrc FileType gitcommit map <buffer> ; odvlzi
autocmd vimrc FileType gitcommit map <buffer> <leader>C :Gcommit\ --verbose<cr>
autocmd vimrc FileType gitrebase map <buffer> ; :execute("only\|bo Gvsplit " . substitute(getline('.'), '^\k\+\s\(\x\+\)\s.*$','\1','g'))<cr>
" autocmd vimrc FileType gitcommit map <buffer> ; :only<cr>dv
" Enable spell checking for commit messages
autocmd vimrc BufNewFile,BufReadPost *.git/COMMIT_EDITMSG setfiletype gitcommit | set spell | silent! nunmap ;
autocmd vimrc BufReadPost /tmp/cvs*,svn-commit.tmp*,*hg-editor* setlocal spell
" }}}
Plug 'gregsexton/gitv'
Plug 'junegunn/gv.vim' "{{{
nmap <leader>gv :GV<cr>
nmap <leader>gV :GV!<cr>
vmap Gv :GV!<cr>
vmap GV :GV?<cr>
autocmd vimrc FileType GV map <buffer> ; o
autocmd vimrc FileType GV map <buffer> l ;
autocmd vimrc FileType GV map <buffer>  O
" }}}
Plug 'AndrewRadev/splitjoin.vim'"{{{
let g:splitjoin_quiet=0
"}}}
Plug 'inkarkat/vim-CompleteHelper' "{{{
Plug 'inkarkat/vim-ingo-library'
Plug 'vim-scripts/PrevInsertComplete'
Plug 'vim-scripts/MotionComplete'
Plug 'vim-scripts/BracketComplete'
Plug 'vim-scripts/MultiWordComplete'
Plug 'inkarkat/vim-WORDComplete'
Plug 'https://github.com/vim-scripts/AlphaComplete'
Plug 'https://github.com/inkarkat/vim-PatternComplete'
"}}}
" Plug 'inkarkat/vim-session'"{{{
" let g:session_autoload = 'yes'
" let g:session_default_to_last = 'yes'
" let g:session_autosave = 'yes'
" let g:session_autosave_to = 'yes'
" let g:session_autosave_periodic = 'yes'
" let g:session_autosave_periodic = 'yes'
" let g:session_persist_globals = ['&makeprg', '&makeef']
" -save session periodically
" -check vim-obsession
autocmd vimrc VimLeave * mksession! ~/.vim/lastsession
" TODO: Use fnamemodify() or fnameescape()
" let &viminfo="'50,<1000,s100,:9999,/9999,n~/.vim/viminfo/" . substitute($PWD, "/\| ", "_", "g")
let &viminfo="'50,<1000,s100,:9999,/9999,n~/.vim/viminfo/" . substitute(substitute($PWD, "/", "_", "g"), " ", "_", "g")
"}}}
Plug 'airblade/vim-gitgutter', {'on': 'GitGutterToggle'} "{{{
let g:gitgutter_highlight_lines = 0
let g:gitgutter_override_sign_column_highlight = 1
highlight clear SignColumn
highlight GitGutterAdd ctermbg=black
map <leader>gG :GitGutterToggle<cr>
" }}}
Plug 'junegunn/vim-github-dashboard', {'on': 'GHActivity'} "{{{
let g:github_dashboard = { 'username': 'dsh2', 'password': $GHD_GITHUB_TOKEN }
" }}}
" Plug 'zhaocai/GoldenView.Vim' "{{{
" let g:goldenview__enable_default_mapping = 0
" let g:goldenview__ignore_urule = { 'filetype': ['man'] }
" nmap <silent> <c-w>= <Plug>GoldenViewResize
" autocmd BufEnter * call s:ResizeSplit()
" command ResizeSplit call s:ResizeSplit()
"}}}
Plug 'Shougo/unite.vim', {'on': 'Unite'} "{{{
nnoremap <silent> <leader>lb :<C-u>Unite buffer file_mru<CR>
nnoremap <silent> <F3> :Unite buffer<cr>
autocmd vimrc FileType unite map <buffer> <F3> q
Plug 'Shougo/vimproc.vim', { 'do': 'make' }
Plug 'Shougo/neomru.vim'
let g:neomru#time_format='%F %T '
let g:neomru#update_interval=60
"}}}
" Plug 'will133/vim-dirdiff', { 'on': 'DirDiff'} "{{{
" let g:DirDiffExcludes = "*.class,*.exe,.*.swp,*.so,*.img"
" Plug 'rickhowe/diffchar.vim'
" let g:DiffUnit = 'Word1'
" let g:DiffColors = 0 " fixed color
" " let g:DiffColors = 1 " 4 colors in fixed order
" Plug 'rickhowe/spotdiff.vim'
" noremap <leader>ldt :Diffthis<CR>
" noremap <leader>ldr :Diffoff!<CR>
" noremap <leader>ldo :Diffoff!<CR>
" " }}}
Plug 'Ilink/cscope-quickfix' "{{{
set cscopepathcomp=2
" set cscopeprg=/opt/local/bin/cscope
set cscopetag
set cscopequickfix=s-,c-,d-,i-,t-,e-
set cscoperelative
if filereadable("cscope.out") 
    silent! cscope add cscope.out
endif
set cscopeverbose  
function! QfLlNext()
    windo if &l:buftype == "quickfix" | silent! cnext | if &l:buftype == "location" | silent! lnext | endif | endif
endfunction
nnoremap <C-n> :call QfLlNext()<cr>
function! QfLlPrevious()
    windo if &l:buftype == "quickfix" | silent! cprevious | if &l:buftype == "location" | silent! lprevious | endif | endif
endfunction
nnoremap <C-p> :call QfLlPrevious()<cr>
" FIXME: does not work :(
autocmd vimrc FileType qf set norelativenumber
autocmd vimrc FileType qf wincmd J
"}}}
Plug 'hari-rangarajan/CCTree' "{{{
" TODO:
" let g:CCTreeCscopeDb = ".cscope/out"
" autocmd vimrc BufNewFile,BufReadPost CCTree-View nnoremap q :echo q
let g:CCTreeCscopeDb = "cscope.out"
let g:CCTreeDisplayMode = 1
let g:CCTreeHilightCallTree=1
let g:CCTreeMinVisibleDepth = 3
let g:CCTreeOrientation = "topleft"
let g:CCTreeRecursiveDepth = 1
let g:CCTreeUseUTF8Symbols = 1
let g:CCTreeWindowWidth = -1
let g:CCTreeDbFileMaxSize = 40000000
let g:CCTreeKeyHilightTree = '<C-h>'        " Static highlighting
let g:CCTreeKeyDepthPlus = '='
let g:CCTreeKeyDepthMinus = '-'
" -re-use tree control code for uftrace, etc
" map ; to preview
" -add command to load db to cscope load event
" -use async-run or similar for that
" }}}
" Plug 'text objects' {{{
Plug 'kana/vim-textobj-user'
Plug 'kana/vim-textobj-indent'
Plug 'kana/vim-textobj-fold'
let g:textobj_function_no_default_key_mappings = 1
xmap aF <Plug>(textobj-function-a)
vmap aF <Plug>(textobj-function-a)
xmap iF <Plug>(textobj-function-i)
vmap iF <Plug>(textobj-function-i)
Plug 'kana/vim-textobj-function'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-entire'
Plug 'kana/vim-textobj-lastpat'
" Plug 'paulhybryant/vim-textobj-path'
Plug 'coderifous/textobj-word-column.vim'
Plug 'vim-scripts/argtextobj.vim'
Plug 'thinca/vim-textobj-between'
Plug 'adriaanzon/vim-textobj-matchit'
xmap a%  <Plug>(textobj-matchit-a)
omap a%  <Plug>(textobj-matchit-a)
xmap i%  <Plug>(textobj-matchit-i)
omap i%  <Plug>(textobj-matchit-i)
Plug 'beloglazov/vim-textobj-quotes'
xmap q iq
omap q iq
" Plug 'rhysd/vim-textobj-continuous-line'
Plug 'kana/vim-textobj-datetime'
Plug 'vim-utils/vim-space'
" Plug 'rsrchboy/vim-textobj-heredocs'
Plug 'Julian/vim-textobj-variable-segment'
Plug 'whatyouhide/vim-textobj-xmlattr'
" }}}
Plug 'gcmt/taboo.vim' "{{{
let g:taboo_tab_format = "[%N|%f(%W)%m] "
" let g:taboo_tab_format = "[%N|%a/%f(%W)%m] "
let g:taboo_renamed_tab_format ="[%N|%l%m(%W)] "
" TODO: Make this work
let g:taboo_unnamed_tab_label = '%a'
nmap <leader>tR :TabooReset<cr>
nmap <leader>tr :TabooRename
nmap <leader>tn :TabooOpen
nmap <leader>, gT
nmap <leader>. gt
map <c-1> gT
map <c-2> gt
" TODO: Make this indeed pwd, same for TabooOpen
nmap <leader>N :tabnew<cr>:pwd<cr>
nmap <leader>tn :$tabnew<cr>
nmap <leader>tc :tabclose<cr>
" }}}
Plug 'francoiscabrol/ranger.vim', {'on': 'Ranger'}"{{{
map <leader>f :Ranger<cr>
"}}}
Plug 'milkypostman/vim-togglelist' "{{{
nmap <leader><c-j> :colder<CR>
nmap <leader><c-k> :cnewer<CR>
" }}}
Plug 'mbbill/undotree', {'on': 'UndotreeToggle'} "{{{
let g:undotree_WindowLayout = 2
let g:undotree_SetFocusWhenToggle = 1
" let g:undotree_DiffCommand = "diff -y"
let g:undotree_DiffCommand = "diff -U 5"
let g:undotree_DiffpanelHeight = 25
let g:undotree_TreeNodeShape = "o"
nnoremap <F4> :UndotreeToggle<cr>
autocmd vimrc FileType undotree nmap <buffer> ; <cr>
" }}}
Plug 'vim-pandoc/vim-pandoc', {'for': ['pandoc', 'markdown']} "{{{
Plug 'vim-pandoc/vim-pandoc-syntax'
autocmd vimrc FileType markdown set wrap
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
"}}}
Plug 'chrisbra/csv.vim', {'for': 'csv' } "{{{
" hi CSVColumnEven term=bold ctermbg=4 guibg=DarkBlue
" hi CSVColumnOdd  term=bold ctermbg=5 guibg=DarkMagenta
" hi link CSVColumnOdd MoreMsg
" hi link CSVColumnEven Question
" autocmd vimrc Filetype csv hi CSVColumnEven ctermbg=4
" autocmd vimrc Filetype csv hi CSVColumnOdd  ctermbg=5
let g:csv_no_column_highlight = 0
let b:csv_arrange_align = 'l*'
let g:csv_arrange_align = 'l*'
let g:csv_autocmd_arrange = 1
" TODO: If readonly set nofile?
map <leader>CT :setlocal modifiable<cr>:setlocal filetype=csv<cr>let g:csv_delim="\t"<cr>ggVG:ArrangeColumn!<cr>let b:csv_headerline = 0<cr>
map <leader>C; :setlocal modifiable<cr>:setlocal filetype=csv<cr>let g:csv_delim=";"<cr>ggVG:ArrangeColumn!<cr>let b:csv_headerline = 0<cr>
map <leader>CC :setlocal modifiable<cr>:setlocal filetype=csv<cr>ggVG:ArrangeColumn!<cr>let b:csv_headerline = 0<cr>
map <leader>CS :set noreadonly<cr>:setlocal modifiable<cr>:%s/\s\{1,\}/,/<cr>:let @/=""<cr>:setlocal filetype=csv<cr>ggVG:ArrangeColumn!<cr>let g:csv_headerline=0<cr>0
autocmd vimrc BufRead,BufNewFile *.csv set filetype=csv
" TODO: Add toggle reverse order support
autocmd vimrc FileType csv map <buffer> <leader>cs :Sort<cr>
autocmd vimrc FileType csv map <buffer> <leader>c/ :CSVSearchInColumn
autocmd vimrc FileType csv map <buffer> <leader>ca :Analyze<cr>
" TODO: Add maps for
" -Toggle aligns (left, right, etc.)
" -Number types (hex, etc.)
" }}}
" Plug 'hsanson/vim-android' "{{{
" let g:android_sdk_path = $ANDROID_SDK_ROOT
" let g:android_airline_android_glyph = 'U+f17b'
" " }}}
Plug 'kelwin/vim-smali', {'for': 'smali'} "{{{
"Plug 'alderz/smali-vim'
autocmd vimrc BufRead *.smali set filetype=smali
" }}}
Plug 'xolox/vim-lua-ftplugin', {'for': 'lua'} "{{{
Plug 'xolox/vim-misc'
" }}}
Plug 'davidhalter/jedi-vim', {'for': 'python'} "{{{
let g:jedi#completions_command = "<C-space>"
let g:jedi#goto_command = "<c-]>"
let g:jedi#auto_close_doc = 0
let g:jedi#show_call_signatures = 2
let g:jedi#show_call_signatures_delay = 0
let g:jedi#use_tabs_not_buffers = 0
let g:jedi#use_splits_not_buffers = ""
let g:jedi#squelch_py_warning = 1
" let g:jedi#force_py_version = 3.4
" Plug 'nvie/vim-flake8'
" Plug 'xolox/vim-pyref'
" }}}
Plug 'elzr/vim-json', {'for': 'json'}  "{{{
" autocmd vimrc FileType json set conceallevel=0
let g:vim_json_syntax_concealcursor = 0
" }}}
Plug 'scrooloose/nerdtree' "{{{
Plug 'Xuyuanp/nerdtree-git-plugin'
let g:NERDTreeShowIgnoredStatus = 1
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "M",
    \ "Staged"    : "+",
    \ "Untracked" : "N",
    \ "Renamed"   : "R",
    \ "Unmerged"  : "<",
    \ "Deleted"   : "D",
    \ "Dirty"     : ">",
    \ "Clean"     : "C",
    \ "Ignored"   : 'I',
    \ "Unknown"   : "?"
    \ }
let NERDTreeIgnore = ['\~$[[file]]', '\.pyc$[[file]]']
let NERDTreeShowHidden = 1
let NERDTreeWinSize = 46
let NERDTreeMinimalUI = 1
autocmd vimrc FileType nerdtree map <buffer> l oj^
"autocmd vimrc FileType nerdtree map <buffer> O mo
autocmd vimrc FileType nerdtree map <buffer> h x^
autocmd vimrc FileType nerdtree map <buffer> ; go
autocmd vimrc FileType nerdtree map <buffer> <F2> :NERDTreeClose<cr>
nnoremap <F2> :NERDTreeFind<cr>
" }}}
Plug 'tyru/open-browser.vim' "{{{
let g:netrw_nogx = 1 " disable netrw's gx mapping.
nmap gx <Plug>(openbrowser-smart-search)
vmap gx <Plug>(openbrowser-smart-search)
command! OpenBrowserCurrent execute "OpenBrowser" "file://" . expand('%:p:gs?\\?/?')
map gX OpenBrowserCurrent
" let g:openbrowser_browser_commands = [
"         \   {'name': 'google-chome',
"         \    'args': ['start', '{browser}', '{uri}']}
"         \]
"}}}
Plug 'rhysd/open-pdf.vim', {'for': 'pdf'}  "{{{
let g:pdf_convert_on_edit = 1
let g:pdf_convert_on_read = 1
" }}}
" Plug 'vim-scripts/taglist.vim', {'on': 'TlistToggle'}  {{{
" let Tlist_Use_Right_Window = 1
" let Tlist_WinWidth = 55
" let Tlist_Display_Prototype = 1
" let Tlist_Exit_OnlyWindow = 1
" let Tlist_GainFocus_On_ToggleOpen = 0
" let Tlist_Highlight_Tag_On_BufEnter = 1
" let Tlist_Auto_Open = 1
" let Tlist_Show_One_File = 1
" map <leader>t :TlistToggle<cr>
" }}}
Plug 'majutsushi/tagbar' " ", {'on': 'TagbarToggle'}  " {{{
Plug 'hushicai/tagbar-javascript.vim'
let g:tagbar_autoclose = 0
" TODO: Add support for percent instead of number of characters
let g:tagbar_width = 40
let g:tagbar_zoomwidth = 0
let g:tagbar_compact = 1
let g:tagbar_indent = 1
let g:tagbar_show_linenumbers = 0
let g:tagbar_autofocus = 0
let g:tagbar_hide_nonpublic = 0
let g:tagbar_autoshowtag = 1
let g:tagbar_autopreview = 0
map <leader>tt :silent! TagbarToggle<cr>
autocmd vimrc VimEnter * nested :silent! call tagbar#autoopen(1)
" autocmd vimrc VimEnter * nested :silent! TagbarToggle
autocmd vimrc FileType tagbar map <buffer> ; p
autocmd vimrc FileType tagbar map <buffer> A x
autocmd vimrc FileType tagbar map <buffer> l za
autocmd vimrc FileType tagbar map <buffer> h za
" }}}
Plug 'jeetsukumaran/vim-markology' "{{{
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
" Plug 'mileszs/ack.vim', {'on': 'Ack'} {{{
" let g:ackhighlight = 1
" let g:ack_autofold_results = 0
" let g:ackpreview = 0
" let g:ack_use_dispatch = 1
" map <leader>a :Ack! \\b<cword\\b><CR>
" }}}
Plug 'brookhong/ag.vim', {'on': 'Ag'}  "{{{
" map <leader>a :Ag! \\b<cword\\b><CR>
map <leader>a :Ag! <cword><CR>
" }}}
Plug 'szw/vim-maximizer', {'on': 'MaximizerToggle'}  "{{{
nnoremap <c-w>m :MaximizerToggle<cr>
nnoremap <c-w><c-m> :MaximizerToggle<cr>
"}}}
Plug 'bling/vim-airline' "{{{
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline_detect_modified=1
let g:airline_detect_spelllang=1
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
" }}}
Plug 'tpope/vim-dispatch' "{{{
" map <leader>M :update<cr>:Make<cr>:copen<cr>/error:<cr>n
map <leader>m :update<cr>:Make<cr>:checktime<cr>
" }}}
Plug 'sickill/vim-pasta' "{{{
let g:pasta_disabled_filetypes = ['python', 'coffee', 'yaml', 'tagbar']
"}}}
Plug 'vim-scripts/AnsiEsc.vim', {'on': 'AnsiEsc'} "{{{
map <leader>W :AnsiEsc<cr>
" Remove ansi escape sequence
if executable("strip-ansi")
	function! StripAnsi()
		:silent %!strip-ansi
		echo "StripAnsi: called strip-ansi-cli"
	endfunction
else
	function! StripAnsi()
		let @/='\v%x1b[(\d{0,3})(;\d{1,3}){0,5}(m|K)'
		silent! execute "%s:::"
		echo "StripAnsi: search-and-replace"
	endfunction
endif
command! StripAnsi call StripAnsi()
map <leader>Q :StripAnsi<cr>
"}}}
Plug 'romgrk/winteract.vim', {'on': 'InteractiveWindow'} "{{{
nmap gw :InteractiveWindow<CR>
"}}}
Plug 'Shougo/vinarise.vim', {'on': 'Vinarise'} "{{{
map <leader>V :Vinarise<cr>
"}}}
Plug 'nathanaelkane/vim-indent-guides', {'on': 'IndentGuidesToggle'} "{{{
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2
"}}}
Plug 'junegunn/vim-peekaboo' "{{{
let g:peekaboo_window = 'vertical botright 51new'
let g:peekaboo_delay = 0
let g:peekaboo_compact = 0
"}}}
Plug 'Chiel92/vim-autoformat', {'on': 'Autoformat'} "{{{
let g:autoformat_verbosemode=1
" TODO: try to understand why resetting syn is necessary
map <leader>A :Autoformat \| syn off \| syn on \" set foldlevel=1<cr>
"}}}
Plug 'tpope/vim-commentary' "{{{
autocmd vimrc FileType sshconfig,sshdconfig,shell,i3config,jq,resolv setlocal commentstring=#\ %s
nmap gcC yygccp
"}}}
Plug 'fatih/vim-go', {'for': 'go'} "{{{
map gD :GoDocBrowser<cr>
"}}}
Plug 'dsh2/diff-fold.vim', {'for': 'diff'} "{{{
autocmd vimrc FileType diff map <buffer> <leader>d <Plug>DiffFoldNav
"}}}
Plug 'idanarye/vim-merginal' "{{{
" Plug 'idanarye/vim-merginal', {'on': 'MerginalToggle'} "
" TODO: Find out why on-load tag does not work
map <leader>gm :MerginalToggle<cr>
map <leader>y :MerginalToggle<cr>
"}}}
Plug 'skywind3000/asyncrun.vim', {'on': 'AsyncRun'} "{{{
map <leader>B :AsyncRun binwalk %<cr>
autocmd vimrc User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)
autocmd vimrc BufReadPost .\\\{0,1\}vimrc nnoremap <buffer> <silent> <cr> 0f/lgf
"}}}
Plug 'atimholt/spiffy_foldtext' "{{{
" TODO: Add more preview text, squece as much content as possible?
let g:SpiffyFoldtext_format='%c{-} %<%f{-}| %4n lines |-%l{--}'
"}}}
Plug 'dsh2/HiCursorWords' "{{{
let g:HiCursorWords_delay = 10
let g:HiCursorWords_hiGroupRegexp = ''
" let g:HiCursorWords_style='term=reverse cterm=reverse gui=reverse'
" let g:HiCursorWords_linkStyle='ErrorMsg'
" let g:HiCursorWords_linkStyle='IncSearch'
let g:HiCursorWords_linkStyle='MatchParen'
" let g:HiCursorWords_linkStyle='VisualNOS'
" let g:HiCursorWords_debugEchoHiName = 1
let g:HiCursorWords_debugEchoHiName = 0
" }}}
Plug 'flatcap/vim-keyword' "{{{
" TODO: Make this work
map <leader>k <plug>KeywordToggle
map <leader>K :call keyword#KeywordClear()<cr>
let g:keyword_group = 'keyword_group'
" let g:keyword_highlight = 'ctermbg=darkred cterm=underline'
let g:keyword_highlight = 'ctermbg=darkred'
"}}}
Plug 'vim-scripts/LargeFile'"{{{
let g:LargeFile = 50
set synmaxcol=2048"}}}
Plug 'w0rp/ale' "{{{
let g:airline#extensions#ale#enabled = 1
let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_open_list = 0
let g:ale_keep_list_window_open = 1
let g:ale_fix_on_save = 1
let g:ale_lint_on_enter = 1
let g:ale_lint_on_text_changed = "never"
let g:ale_open_list = "never"
" }}}
Plug 'machakann/vim-highlightedyank'"{{{
let g:highlightedyank_highlight_duration = 333
if !exists('##TextYankPost')
    map y <Plug>(highlightedyank)
endif
"}}}
" Plug 'scrooloose/syntastic' "{{{
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
" }}}
" Plug YouCompleteMe {{{
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
Plug 'szw/vim-g'"{{{
map <leader>G :Google<cr>"}}}
" Plug tmux {{{
Plug 'tmux-plugins/vim-tmux', {'for': 'tmux'}
autocmd vimrc BufRead tmux.conf set filetype=tmux
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'wellle/tmux-complete.vim'
let g:tmuxcomplete#trigger = 'omnifunc'
"}}}
" Plug colorschemes {{{
Plug 'morhetz/gruvbox'
Plug 'rhysd/vim-color-spring-night'
Plug 'Lokaltog/vim-distinguished'
Plug 'altercation/vim-colors-solarized'
let g:solarized_termcolors=256
let g:solarized_contrast="normal"
let g:solarized_visibility="normal"
let g:solarized_diffmode="high"
Plug 'chriskempson/vim-tomorrow-theme'
Plug 'jnurmine/Zenburn'
Plug 'junegunn/seoul256.vim'
Plug 'nanotech/jellybeans.vim'
Plug 'pwntester/VimCobaltColourScheme'
Plug 'pwntester/cobalt2.vim'
Plug 'reedes/vim-colors-pencil'
Plug 'tomasr/molokai'
Plug 'xolox/vim-colorscheme-switcher'
" Plug 'govindkrjoshi/CSApprox'
" Plug 'KevinGoodsell/vim-csexact'
" Plug 'AlessandroYorba/Monrovia'
" }}}
" Plug rest... {{{
Plug 'mogelbrod/vim-jsonpath'
Plug 'pedrohdz/vim-yaml-folds'
Plug 'matze/vim-ini-fold'
Plug 'tpope/vim-bundler'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-rails'
" Plug 'tpope/vim-sleuth'
Plug 'Shougo/echodoc.vim'
Plug 'Quramy/tsuquyomi'
Plug 'tommcdo/vim-exchange'
Plug 'szw/vim-dict'
Plug 'google/vim-searchindex'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'Konfekt/vim-CtrlXA'
Plug 'Valloric/vim-operator-highlight'
Plug 'tmhedberg/matchit'
Plug 'chrisbra/Colorizer'
Plug 'chrisbra/Recover.vim'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-system-copy'
Plug 'dkprice/vim-easygrep'
Plug 'dsh2/vim-man' " TODO: { 'dir': '~/.vim-man', 'do': 'git pull orig' }
Plug 'dsh2/vim-unimpaired'
Plug 'embear/vim-foldsearch'
Plug 'ervandew/matchem'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'lzap/vim-selinux', {'for': 'te'}
Plug 'maksimr/vim-yate', {'for': 'yate'}
Plug 'mboughaba/i3config.vim', {'for': 'i3config'}
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-afterimage'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-rsi'
Plug 'tpope/vim-tbone'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'vim-scripts/VCard-syntax', {'for': 'vcard'}
Plug 'vim-scripts/info.vim', {'on': 'Info'}
Plug 'vim-scripts/renamer.vim', {'on': 'Renamer'}
Plug 'wannesm/wmgraphviz.vim', {'for': 'dot'}
Plug 'z0mbix/vim-shfmt', { 'for': 'sh' }
Plug 'frioux/vim-regedit'
" }}}
call plug#end()
" }}}
" Global options {{{
set autoindent
set autowrite
set backspace=indent,eol,start
set backupdir=~/.vim/backup/
set cmdheight=1
set cmdwinheight=10
set complete+=kt
set concealcursor=n
set conceallevel=0
set clipboard=unnamedplus
set diffopt=
" set diffopt=filler,context:4
set dir=~/.vim/swo
set encoding=utf8
set exrc
let g:xml_syntax_folding=1
set foldmethod=syntax
set foldlevelstart=99
" set foldopen=hor,mark,percent,quickfix,search,tag,undo
set foldopen=hor,search,quickfix,tag
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
set relativenumber
set nospell
set nowrap
set linebreak
set nowrapscan
set number
set previewheight=14
set ruler
au BufEnter,BufNew,OptionSet * if &diff | set scrolloff=0 | else | set scrolloff=999 | endif
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
set tabstop=4
set tags+=$HOME/.usr.include.tags
set title
set titleold=''
set titlestring=%t%(\ %M%)%(\ (%{expand(\"%:p:h\")})%)%(\ %a%)\ -\ %{v:servername}
set notimeout
set nottimeout
set ttimeoutlen=50
set undodir=~/.vim/undodir/
set undofile
set updatetime=500
set wildignore=*~,*.o,*.obj,*.aux
set wildmenu
set wildmode=list:longest,full
autocmd vimrc BufNewFile,BufReadPost Vagrantfile setfiletype ruby
autocmd vimrc BufNewFile,BufReadPost .clang-format setfiletype yaml

" }}}
" Mappings {{{
nmap Q :qall<cr>
nmap <leader>J :set ft=json<cr><leader>S
map  
map  :bnext<cr>
map <c-.> :bprev<cr>
map <leader><c-l> :redraw!<cr>:echo "Redraw!"<cr>
nmap <leader>o :silent !open "%"<cr>
nmap <nowait> <leader>s :update<cr>
" TODO: PWD vs. CWD
map <silent><leader>R :source ~/.vimrc\| if filereadable("./.vimrc") \| source ./.vimrc \|  endif<cr>
map <leader>S :syn off \| syn on \| se foldlevel=1<cr>
nnoremap <cr> :nohlsearch<CR>/<BS><CR>
imap <NUL> <space>h
" TODO: Filter ansi escape sequences from filename when file not found
nnoremap gf gF
nnoremap gF :tabedit <cfile><cr>
map <c-w>v <c-w>v<c-w>l
vmap DP :diffput<cr>
vmap DG :diffget<cr>
nmap <leader>DD :diffthis<CR>
nmap <leader>DO :diffoff<CR>
nmap <leader>DS :vertical diffsplit<CR>
" TODO: Clean this up...
nnoremap <leader>cd :execute ":lcd " . substitute(expand("%:p:h"), ' ', '\\ ', 'g')<cr>:pwd<cr>"<cr>
nnoremap U <c-r>
nmap <c-q> :cq<cr>
nmap <leader>P :pwd<cr>
nmap zx za
nmap <leader>BD :bdelete!<cr>
" TODO: add toggle for this: coG?
function! ToggleLineBreakMode()
	if maparg("j", "n") == "gj"
		unmap j
		unmap k
		unmap gj
		unmap gk
		" unmap 0
		" unmap g0
		echo "NOT breaking lines on movement."
    else
		nnoremap gj j
		nnoremap gk k
		nnoremap j gj
		nnoremap k gk
		" nnoremap g0 0
		" nnoremap 0 g0
		echo "Breaking lines on movement."
    endif
endfunction
nmap coG :call ToggleLineBreakMode()<cr>

" Delete all matching lines
vmap <silent> <leader>D g*:%g//d<cr>
nmap <silent> <leader>D v$g*:%g//d<cr>
" TODO
" -Add convert to hex/bin/etc.
" -Parse as data-uri
" -Encode/decode as base64, uu, etc.
" -ROT13
" -Disassem ARM/Intel
map <leader>d :echo strftime('%F  %T', expand("<cword>"))<cr>
" Split navigations
nnoremap <C-j> <C-w><C-j>
nnoremap <C-k> <C-w><C-k>
nnoremap <C-l> <C-w><C-l>
nnoremap <C-h> <C-w><C-h>

function! YankUp(string)
	let @+=a:string
	if executable("clip.exe") | call system("clip.exe", a:string) | endif
	if !empty($TMUX) && executable("tmux") | call system("tmux load-buffer -", a:string) | endif
	if !empty($DISPLAY)
		if executable("xclip") | call system("xclip -selection clipboard -in", a:string)
		elseif executable("xsel") | call system("xsel -bi", a:string)
		endif
	endif
	echo "YANK-UP: \"" . strtrans(a:string) . "\""
endfunction

" TODO: check if there is somethinkg like "register pending" mode
" command! YankUp :call YankUp(@")|echo "YankUp: " . strtrans(@")
command! YankUp :call YankUp(@")
nmap YY :YankUp<cr>

map Ypa :call YankUp(expand("%:p"))<cr>
map Ypp :call YankUp(expand("%:p"))<cr>
map Ypl :call YankUp(expand("%:t") . ":" . line("."))<cr>
map YP :call YankUp(expand("%:p") . ":" . line("."))<cr>
map YpL :call YankUp(expand("%:p") . ":" . line("."))<cr>
map Ypr :call YankUp(expand("%:."))<cr>
map Yp. :call YankUp(expand("%:."))<cr>
" TODO: add current function (c, cpp, py, etc.)
" }}}
" Special operations {{{
" Setup colorschema{{{
" au BufEnter,BufNew,OptionSet * if &diff | let g:solarized_diffmode="normal" | colorscheme solarized | set diffopt= | else | colorscheme Tomorrow-Night | endif
" TODO:
" -output name of schema
" -make schema persist over session
nmap <F6> :NextColorScheme<CR>
map <leader>n :colorscheme Tomorrow-Night<cr>
map <leader>c :colorscheme
try
colorscheme seoul256 | let g:airline_theme='qwq'
" colorscheme gruvbox| let g:airline_theme='pencil'
" colorscheme spring-night | let g:airline_theme='night_owl'
" colorscheme solarized | let g:airline_theme='solarized_flood'
catch
endtry
hi Folded cterm=NONE
nnoremap zO zczO
nnoremap zm zM
nnoremap zM zm
" TODO: Add "default" foldexprs for
" -ascii trees (uftrace,etc.)
" -dash/line separators
" foldexpr for path-like lists
function! FoldExprAsciiTree(lnum)
    return len(split(getline(a:lnum), "/"))
endfunction
function! FoldExprPath(lnum)
    return len(split(getline(a:lnum), "/"))
endfunction
" foldexpr for single space indention
function! FoldExprSpace(lnum)
    return matchend(getline(a:lnum), "\\S")
endfunction
set foldexpr=FoldExprSpace(v:lnum)
"}}}
" Open log files at the bottom of the file{{{
" TODO: autocmd.txt is not so clear about the the interpretation of slashes in face of multiple comma-separated {pat}s
autocmd vimrc BufReadPost *.log normal G
autocmd vimrc BufReadPost */log/* normal G
autocmd vimrc BufReadPost *.log :set filetype=messages
"}}}
" Restore last position in file upon opening a file{{{
autocmd BufReadPost * call RestorePosition()
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
"}}}
" Configure help system {{{
" runtime! ftplugin/man.vim
nmap K :exe "Vman " . expand("<cword>") <CR>
autocmd vimrc FileType man set sidescrolloff=0
autocmd vimrc FileType man wincmd L
let g:ft_man_open_mode = 'vert'
let g:ft_man_folding_enable = 1

autocmd vimrc FileType vim nmap <buffer> K :exe "help " . expand("<cword>")<CR>
autocmd vimrc FileType help nmap <buffer> q <c-w>c
autocmd vimrc FileType help set nonumber
autocmd vimrc FileType help set sidescrolloff=0
autocmd vimrc FileType help wincmd L
" autocmd vimrc FileType help wincmd L | vert resize 80
" }}}
" Setup cursorcolumn {{{
" Add a cursorline(/cursorcolumn) to the active window
" autocmd vimrc BufWinLeave * set nocursorline |
"	    \ highlight CursorLineNr ctermbg=grey

autocmd vimrc BufRead,BufNewFile *.strace set filetype=strace
autocmd vimrc BufWinEnter * set cursorline |
	    \ highlight CursorLineNr ctermfg=white |
	    \ highlight CursorLineNr ctermbg=red |
	    \ highlight CursorLine cterm=underline
set cursorline
set cursorcolumn
" }}}
" Setup listchars {{{
" set listchars=tab:\|\ ,trail:+,extends:>,precedes:<,nbsp:.
" TODO: the following setting gives very slow rendering on macOS
set listchars=tab:‣\ ,trail:_,extends:↦,precedes:↤,nbsp:∙
" set listchars=tab:→\ ,trail:·,eol:¬,extends:…,precedes:…
" let &showbreak = '↳'
" set list
highlight SpecialKey ctermfg=DarkRed ctermbg=NONE
highlight NonText ctermfg=DarkGreen ctermbg=NONE
" }}}
" Setup spell checking {{{
hi SpellBad ctermbg=none ctermfg=red cterm=undercurl
nmap zz ]seas
nmap zZ :spellr<cr>
set lazyredraw
au BufRead *.md set filetype=markdown | if expand("%:p") =~ '.*/Notizen/.*' | echo "spell german" | setl spelllang="de_20" | else | echo "NO german" | endif
" }}}
" Function: removes trailing spaces {{{
command! RemoveTrailingSpaces call RemoveTrailingSpaces()
function! RemoveTrailingSpaces()
    %s/\s*$//
endfunction
"}}}
" Function: page output of vim commands {{{
command! -nargs=1 -complete=command Redir call <SID>Redir(<f-args>)
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
" }}}"
" Function: relax search pattern {{{
" TODO: merge with Andrew Radev
" TODO: relax numbers to \d+
command! -nargs=0 RelaxSearchPattern call <SID>RelaxSearchPattern()
function! s:RelaxSearchPattern() abort
    let @/=substitute(@/, "^\\V", "", "g")
    let @/=substitute(@/, "_", ".*", "g")
    let @/=substitute(@/, " ", ".*", "g")
    let @/ = inputdialog("New search pattern: ", @/)
endfunction
" TODO: Find out why first mapping does not work
" nmap <leader>/ call RelaxSearchPattern()
nmap <leader>/ :RelaxSearchPattern<cr>
" }}}
" Function: window swap {{{
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
" }}}
" Miscellaneous {{{
match ErrorMsg /error/
2match WarningMsg /warning/

autocmd vimrc BufRead *.jar,*.apk,*.war,*.ear,*.sar,*.rar set filetype=zip
autocmd vimrc FileType netrw nmap <buffer> q <c-w>c
function! EnableAutoWrite()
    exe ":au FocusLost" expand("%") ":update"
endfunction
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis

autocmd vimrc SwapExists * let v:swapchoice = "o"

" Prevent delay after quitting input mode
" TODO: This seems to be unreliable
set noesckeys
" vim-pstree {{{
" TODO:
" -Make tree generation recurring in the background with a regular interval
" -Add maps
" --to switch from user-generated pstrees and regular generated pstrees
" --Dispatch strace, gdb, r2, etc.
" --To reload procps-files by 'r'
" -Mark timestamps which coincide with user generated updates
" -Diff pstrees
" -Highlight groups for
"  --Unusual flags
"  --interactive programms without tty
"  --load/mem-pressure
"  --uncommon pending syscalls
"  --own tty
" Map for terminal info/search
" R: reload with search on PID
function! ProcessTreePid()
    return substitute(getline('.'), '^\s*\(\d*\)\s.*$','\1','g')
endfunction
let g:pst_fold_columns = 12 " TODO: set this dynamically for current process tree?

let g:pst_fields = [
	\ { 'name': 'pid',       'width':  6, },
	\ { 'name': 'ppid',      'width':  6, },
	\ { 'name': 'stat',      'width':  6, },
	\ { 'name': 'flag',      'width':  2, },
	\ { 'name': 'user',      'width':  8, },
	\ { 'name': 'tty',       'width':  8, 'title': 'TTY' },
	\ { 'name': 'lstart',    'width': 40, },
	\ { 'name': 'wchan',     'width': 15, 'title': 'SYSCALL' },
	\ { 'name': '\%cpu',     'width':  8, },
	\ { 'name': '\%mem',     'width':  8, },
	\ { 'name': 'args', },
    \]
" \ { 'name': 'cgname',      'width':  165, 'detail': 3 },
" \ { 'name': 'sz',   'width': 12, 'title': "" },
" \ { 'name': 'drs',   'width': 12, 'title': "" },
" \ { 'name': 'luid',   'width': 12, 'title': "" },
" \ { 'name': 'lwp',   'width': 12, 'title': "" },
" \ { 'name': 'lxc',   'width': 12, 'title': "" },
" \ { 'name': 'nice',   'width': 12, 'title': "" },
" \ { 'name': 'sess',   'width': 12, 'title': "" },
" \ { 'name': 'seat',   'width': 12, 'title': "" },
" \ { 'name': 'maj_flt',   'width': 12, 'title': "" },
" \ { 'name': 'maj_flt',   'width': 12, 'title': "" },
" \ { 'name': 'min_flt',   'width': 12, 'title': "" },
" \ { 'name': 'cputime',   'width': 12, 'title': "" },
" \ { 'name': 'cputime',   'width': 12, 'title': "CPU-TIME" },
" \ { 'name': 'bsdtime',   'width': 12, 'title': "ACC-TIME" },
" \ { 'name': 'class',   'width': 12, 'title': "CLASS" },

function! Fields_to_psparm()
    let ret = ""
    for field in g:pst_fields
	let ret .= " -o " . field.name
	if has_key(field, "width") && field.width > 0 | let ret .= ":". field.width | endif
	if has_key(field, "title") && len(field.title) > 0 | let ret .= "=". field.title | endif
    endfor
    return ret
endfunction

function! Field_to_colnum(field_name)
    let col=1
    for field in g:pst_fields
	if has_key(field, "width") && field.width > 0 | let col += 1 + field.width | endif
	if field.name == a:field_name
	    break
	endif
    endfor
    return col
endfunction

function! Field_to_colregex(field_name, regex)
    let col=1
    for field in g:pst_fields
	if field.name == a:field_name
	    return "\\%>" . col . "c" . a:regex . "\\%<" . (1 + col + field.width) . "c"
	endif
	let col += field.width
    endfor
endfunction

function! PsEnableCsvVim()
    let col=1
    let fixed_width_string = "1"
    for field in g:pst_fields
	if has_key(field, "width") | let col += 1 + field.width | endif
	let fixed_width_string .= "," . col
    endfor
    set filetype=csv
    let b:csv_fixed_width = fixed_width_string
    CSVInit
endfunction

function! PsSendSignal(pid, signal)
    let line_num = line(".")
    silent! execute "!kill -" . a:signal . " " . a:pid
    ProcessTree()
    execute "norm " . line_num . "G"
endfunction

function! PsFoldExpression(lnum)
    let arg_index = Field_to_colnum("arg")
    if arg_index <= 0 | return 1 | endif
    let match_index = match(getline(a:lnum), '\%>' . arg_index . 'c[|_\ ]*\zs\f*')
    if match_index <= arg_index | return 1 | endif
    return 1 + (match_index - arg_index) / 3
endfunction

function! ProcessTree(...)
    if a:0 == 1 | let pid=a:1 | else | let pid=ProcessTreePid() | endif
    let l:current_line_num = line(".")
    let l:current_fold_level = &foldlevel
    " let @/ = Field_to_colregex("pid", "\\<".pid."\\>")
    " Create new buffer for current pstree
    execute "e ps-" . strftime('%F_%T')
    silent! execute "read !ps -e --forest " . Fields_to_psparm()
    set buftype=nofile filetype=sh cursorline nonumber norelativenumber nowrap
    silent! ALEDisable
    " Cut header from ps output
    silent! norm ggdd0"ad$ddn
	" Delete old header - if any
	wincmd k
	if bufname("") == "HEADER" | bdelete! | endif
    " Move header into separate window
	1new HEADER | set nobuflisted noswapfile | wincmd k | norm "aP0
    set buftype=nofile nonumber norelativenumber nowrap
    let &foldcolumn=g:pst_fold_columns
    wincmd j
    let &foldcolumn=g:pst_fold_columns
    set foldexpr=PsFoldExpression(v:lnum)
    set foldmethod=expr
    let &foldlevel=l:current_fold_level
    set foldenable
    execute "norm " . l:current_line_num . "G"
    " norm zv
    " call PsEnableCsvVim()
    " Add buffer-local mappings
    nnoremap <buffer> r :call ProcessTree()<cr>
    nnoremap <buffer> yp :call YankUp(ProcessTreePid())<cr>
    nnoremap <buffer> s :call PsSendSignal(ProcessTreePid(), "STOP")<cr>
    nnoremap <buffer> c :call PsSendSignal(ProcessTreePid(), "CONT")<cr>
    nnoremap <buffer> K :call PsSendSignal(ProcessTreePid(), "TERM")<cr>
    nnoremap <buffer> ( :call PsSendSignal(ProcessTreePid(), "KILL")<cr>
    nnoremap <buffer> i :let pid=ProcessTreePid()
	\\|execute("tabnew /proc/" . pid . "/stack")
	\\|execute("split \| e /proc/" . pid . "/status")
	\\|execute("NERDTreeFind")
	\\|execute("NERDTreeFind /proc/" . pid . "/fd/0")
	\\|execute("TabooRename ".g:pid)<cr>
    " TODO: Does not work.... :(
    nnoremap <buffer> t :execute("Dispatch! sudo strace -p ") . ProcessTreePid()
endfunction
command! -nargs=* ProcessTree call ProcessTree(<f-args>)

let s:StatusbarHidden = 0
function! StatusbarToggle()
    if s:StatusbarHidden  == 0
	let s:StatusbarHidden = 1
	set noshowmode
	set noruler
	set laststatus=0
	set noshowcmd
    else
	let s:StatusbarHidden = 0
	set showmode
	set ruler
	set laststatus=2
	set showcmd
    endif
endfunction
command! -nargs=0 StatusbarToggle call StatusbarToggle()
function! KeepView(cmd)
    let w = winsaveview()
	exec a:cmd
    call winrestview(w)
endfunction
map <leader>00 :call KeepView('silent! %s/\%x0/\r/')<cr>
map <leader>0m :call KeepView('silent! %s/\%xd//')<cr>
map <leader>0s :call KeepView('silent! %s/\s\+\(\S\)/\r\1/')<cr> " TODO: understand why \zs does NOT work
" TODO: Try to find a way to restrict a mapping on a selection if there is a selection and operate on the entire buffer if there is no selection
map <leader>0, :call KeepView("silent! '<,'>s/,/\r/")<cr>
" }}}
" Prevent vim from moving cursor after leaving insert mode
" TODO: try to understand why vim does this
" au InsertLeave * call cursor([getpos('.')[1], getpos('.')[2]+1])
" }}}
" }}}
