" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < 判断操作系统是否是 Windows 还是 Linux >
" -----------------------------------------------------------------------------
let g:iswindows = 0
let g:islinux = 0
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
else
    let g:islinux = 1
endif

" -----------------------------------------------------------------------------
"  < 判断是终端还是 Gvim >
" -----------------------------------------------------------------------------
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif

" =============================================================================
"                          << 其它 >>
" =============================================================================
" 注：上面配置中的"<Leader>"在本软件中设置为"\"键（引号里的反斜杠），如<Leader>t
" 指在常规模式下按"\"键加"t"键，这里不是同时按，而是先按"\"键后按"t"键，间隔在一
" 秒内，而<Leader>cs是先按"\"键再按"c"又再按"s"键；如要修改"<leader>"键，可以把
" 下面的设置取消注释，并修改双引号中的键为你想要的，如修改为逗号键。
let mapleader = ","

" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()

    function MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if g:islinux
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


" =============================================================================
"                          << 以下为用户自定义配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Vim 插件管理工具配置 >
" -----------------------------------------------------------------------------
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
"     https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

set nocompatible                                      "禁用 Vi 兼容模式
filetype off                                          "禁用文件类型侦测

if g:islinux
    let plugPath='~/.vim/plugged/'
    call plug#begin('~/.vim/plugged')
else
    let plugPath=$HOME.'/vimfiles/plugged/'
    call plug#begin('$HOME/vimfiles/plugged/')
endif

" 以下为要安装或更新的插件，不同仓库都有（具体书写规范请参考帮助）
" General Programming
" {
Plug 'jiangmiao/auto-pairs'             " 自动括号
Plug 'tomasr/molokai'                   " 配色方案
Plug 'altercation/vim-colors-solarized' " 配色方案
Plug 'scrooloose/nerdtree'              " 文件浏览 <leader>e
Plug 'tpope/vim-surround'               " 替换cs]}
Plug 'ctrlpvim/ctrlp.vim'               " c-p查找文件
Plug 'tacahiroy/ctrlp-funky'            " ctrlp拓展 ,fu
Plug 'godlygeek/tabular'                " 通过符号对齐 ,a
Plug 'scrooloose/nerdcommenter'         " 注释 <leader>c<space>
Plug 'vim-airline/vim-airline'          " 状态栏 插件
Plug 'vim-airline/vim-airline-themes'   " 状态栏 插件
Plug 'vim-syntastic/syntastic'          " 语法检查 插件
Plug 'majutsushi/tagbar'                " 编程基本信息汇览 ,tb
Plug 'nathanaelkane/vim-indent-guides'  " 缩进显示
Plug 'dyng/ctrlsf.vim'                  " 搜索
Plug 'terryma/vim-multiple-cursors'     " Multiple cursor
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}     " markdown preview on vim >= 8.1 and neovim
Plug 'vim-scripts/DoxygenToolkit.vim'   " Doxygen
Plug 'ervandew/supertab'                " Super tab
Plug 'SirVer/ultisnips'                 " Track the engine.
Plug 'honza/vim-snippets'               " Snippets are separated from the engine
Plug 'bronson/vim-trailing-whitespace'  " trailing whitespace to be highlighted in red.
Plug 'neovimhaskell/haskell-vim'        " Haskell indentation and highlighting
Plug 'rust-lang/rust.vim'               " Rust language file detection, syntax highlighting formatting and so on
Plug 'xiaohaidao/personal.vim'          " Personal repository

if has("Win64")
Plug 'snakeleon/YouCompleteMe-x64', { 'dir': plugPath.'YouCompleteMe' }
elseif has("Win32")
Plug 'snakeleon/YouCompleteMe-x86', { 'dir': plugPath.'YouCompleteMe' }
else
Plug 'Valloric/YouCompleteMe'           " YouCompleteMe
endif
" }

call plug#end()
"
"" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" -----------------------------------------------------------------------------
"  < 编码配置 >
" -----------------------------------------------------------------------------
" 注：使用utf-8格式后，软件与程序源码、文件路径不能有中文，否则报错
set encoding=utf-8                                    "设置gvim内部编码，默认不更改
set fileencoding=utf-8                                "设置当前文件编码，可以更改，如：gbk（同cp936）
set fileencodings=ucs-bom,utf-8,gbk,cp936,latin-1     "设置支持打开的文件的编码

" 文件格式，默认 ffs=dos,unix
set fileformat=unix                                   "设置新（当前）文件的<EOL>格式，可以更改，如：dos（windows系统常用）
set fileformats=unix,dos,mac                          "给出文件的<EOL>格式类型

if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif

" -----------------------------------------------------------------------------
"  < 编写文件时的配置 >
" -----------------------------------------------------------------------------
filetype on                                           "启用文件类型侦测
filetype plugin on                                    "针对不同的文件类型加载对应的插件
filetype plugin indent on                             "启用缩进
set smartindent                                       "启用智能对齐方式
set expandtab                                         "将Tab键转换为空格
set tabstop=4                                         "设置Tab键的宽度，可以更改，如：宽度为2
set shiftwidth=4                                      "换行时自动缩进宽度，可更改（宽度同tabstop）
set smarttab                                          "指定按一次backspace就删除shiftwidth宽度
set foldenable                                        "启用折叠
"set foldmethod=indent                                "indent 折叠方式
set foldmethod=marker                                 "marker 折叠方式

" 常规模式下用空格键来开关光标行所在折叠（注：zR 展开所有折叠，zM 关闭所有折叠）
nnoremap <space> @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" 当文件在外部被修改，自动更新该文件
set autoread

" 常规模式下输入 cL 清除行尾空格
nmap cL :%s/\s\+$//g<CR>:noh<CR>

" 常规模式下输入 cM 清除行尾 ^M 符号
nmap cM :%s/\r$//g<CR>:noh<CR>

set ignorecase                                        "搜索模式里忽略大小写
set smartcase                                         "如果搜索模式包含大写字符，不使用 'ignorecase' 选项，只有在输入搜索模式并且打开 'ignorecase' 选项时才会使用
" set noincsearch                                       "在输入要搜索的文字时，取消实时匹配

" Ctrl + * 插入模式下光标移动
imap <s-a-k> <Up>
imap <s-a-j> <Down>
imap <s-a-h> <Left>
imap <s-a-l> <Right>
imap <s-a-b> <C-Left>
imap <s-a-f> <C-Right>

" 启用每行超过80列的字符提示（字体变蓝并加下划线），不启用就注释掉
au BufWinEnter * let w:m2=matchadd('Underlined', '\%>' . 80 . 'v.\+', -1)
"
"个人快捷键喜好配置
map <Leader>td :call Do_CsDel() <CR>
map <Leader>tt :call Do_CsTag() <CR>
map <Leader>adt :call SetTitle() <CR>

"更新tags和cscope
func! Do_CsDel()
    let dir = getcwd()
    if filereadable("tags")
        if(g:iswindows==1)
            let tagsdeleted=delete(dir."\\"."tags")
        else
            let tagsdeleted=delete("./"."tags")
        endif
        if(tagsdeleted!=0)
            echohl WarningMsg | echo "Fail to do tags! I cannot delete the tags" | echohl None
            return
        endif
    endif

    if has("cscope")
        silent! execute "cs kill -1"
    endif

    if filereadable("cscope.files")
        if(g:iswindows==1)
            let csfilesdeleted=delete(dir."\\"."cscope.files")
        else
            let csfilesdeleted=delete("./"."cscope.files")
        endif
        if(csfilesdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.files" | echohl None
            return
        endif
    endif

    if filereadable("cscope.out")
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.out")
        else
            let csoutdeleted=delete("./"."cscope.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.out" | echohl None
            return
        endif
    endif

    if (filereadable("cscope.in.out") ||filereadable("cscope.po.out"))
        if(g:iswindows==1)
            let csoutdeleted=delete(dir."\\"."cscope.in.out")
            let csoutdeleted=delete(dir."\\"."cscope.po.out")
        else
            let csoutdeleted=delete("./"."cscope.in.out")
            let csoutdeleted=delete("./"."cscope.po.out")
        endif
        if(csoutdeleted!=0)
            echohl WarningMsg | echo "Fail to do cscope! I cannot delete the cscope.in.out and cscope.po.out" | echohl None
            return
        endif
    endif
endfunc

function Do_CsTag()
    "call Do_CsDel()
    if(executable('ctags'))
        "silent! execute "!ctags -R --c-types=+p --fields=+S *"
        "silent! execute "!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q ."
        silent! execute "!ctags -R"
    endif

    if(executable('cscope') && has("cscope") )
        if !filereadable("cscope.files")
            if(g:iswindows!=1)
                silent! execute "!find . -name '*.h' -o iname "*.hpp" -o -iname '*.s' -o -name '*.c' -o -name '*.cpp' -o -iname '*.go'> cscope.files"
            else
                silent! execute "!dir /s/b *.c,*.cpp,*.h,*.hpp,*.go >> cscope.files"
            endif
        endif
        silent! execute "!cscope -Rbq"
        redraw!
        execute "normal :"

        if filereadable("cscope.out")
            execute "cs add cscope.out"
        endif
    endif
endfunction

func SetComment1()
    call setline(".", "// Copyright (C) ".strftime("%Y")." All rights reserved.")
    call append(line(".")+0, "// Email: oxox0@qq.com. Created in ".strftime("%Y%m"))
    call append(line(".")+1, "")
endfunc

func SetComment2()
    call setline(".", "# Copyright (C) ".strftime("%Y")." All rights reserved.")
    call append(line(".")+0, "# Email: oxox0@qq.com. Created in ".strftime("%Y%m"))
    call append(line(".")+1, "")
endfunc

func SetTitle()
    if expand("%:e") == "py" || expand("%:e") == "sh"
        call SetComment2()
    else
        call SetComment1()
    endif
endfunc


" -----------------------------------------------------------------------------
"  < 界面配置 >
" -----------------------------------------------------------------------------
set number                                            "显示行号
set laststatus=2                                      "启用状态栏信息
set cmdheight=2                                       "设置命令行的高度为2，默认为1
set cursorline                                        "突出显示当前行
" set guifont=YaHei_Consolas_Hybrid:h10                 "设置字体:字号（字体名称空格用下划线代替）
set nowrap                                            "设置不自动换行
set shortmess=atI                                     "去掉欢迎界面

" 设置 gVim 窗口初始位置及大小
if g:isGUI
    " au GUIEnter * simalt ~x                           "窗口启动时自动最大化
    winpos 100 10                                     "指定窗口出现的位置，坐标原点在屏幕左上角
    set lines=38 columns=120                          "指定窗口大小，lines为高度，columns为宽度
endif

" 设置代码配色方案
if g:isGUI
    set background=dark
    set term=xterm
    set t_Co=256
    let g:solarized_termcolors = 256
    colorscheme solarized
else
    colorscheme molokai                 "molokai配色插件开启
    let g:molokai_orginal = 1               "终端配色方案
endif

" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    nmap <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
                \set guioptions-=m <Bar>
                \set guioptions-=T <Bar>
                \set guioptions-=r <Bar>
                \set guioptions-=L <Bar>
                \else <Bar>
                \set guioptions+=m <Bar>
                \set guioptions+=T <Bar>
                \set guioptions+=r <Bar>
                \set guioptions+=L <Bar>
                \endif<CR>
endif

" -----------------------------------------------------------------------------
"  < 其它配置 >
" -----------------------------------------------------------------------------
set writebackup                             "保存文件前建立备份，保存成功后删除该备份
set nobackup                                "设置无备份文件
set noundofile                              "设置无撤销文件
" set noswapfile                              "设置无临时文件
" set vb t_vb=                                "关闭提示音


" =============================================================================
"                          << 以下为常用插件配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < auto-pairs 插件配置 >
" -----------------------------------------------------------------------------
" 用于括号与引号自动补全，不过会与函数原型提示插件echofunc冲突
" 所以我就没有加入echofunc插件

" -----------------------------------------------------------------------------
"  < Surround 插件配置 >
" -----------------------------------------------------------------------------
"  This plugin is a tool for dealing with pairs of "surroundings." Examples of surroundings include parentheses, quotes, and HTML tags. They are closely related to what Vim refers to as text-objects. Provided are mappings to allow for removing, changing, and adding surroundings.
"
"Details follow on the exact semantics, but first, consider the following examples. An asterisk (*) is used to denote the cursor position.
"
"  Old text                  Command     New text ~
"  "Hello *world!"           ds"         Hello world!
"  [123+4*56]/2              cs])        (123+456)/2
"  "Look ma, I'm *HTML!"     cs"<q>      <q>Look ma, I'm HTML!</q>
"  if *x>3 {                 ysW(        if ( x>3 ) {
"  my $str = *whee!;         vllllS'     my $str = 'whee!';
"
"For instance, if the cursor was inside "foo bar", you could type cs"' to convert the text to 'foo bar'.
"
"There's a lot more, check it out at :help surround

" -----------------------------------------------------------------------------
"  < NERDCommenter 插件配置 >
" -----------------------------------------------------------------------------
"NERDCommenter allows you to wrangle your code comments, regardless of filetype. View help :NERDCommenter or checkout my post on NERDCommenter.
"
"QuickStart Toggle comments using <Leader>c<space> in Visual or Normal mode.

" -----------------------------------------------------------------------------
"  < NerdTree 插件配置 >
" -----------------------------------------------------------------------------
"
"NERDTree is a file explorer plugin that provides "project drawer" functionality to your vim editing. You can learn more about it with :help NERDTree.
"
"QuickStart Launch using <Leader>e.
"
"Customizations
"
"    Use <C-E> to toggle NERDTree
"    Use <leader>e or <leader>nt to load NERDTreeFind which opens NERDTree where the current file is located.
"    Hide clutter ('.pyc', '.git', '.hg', '.svn', '.bzr')
"    Treat NERDTree more like a panel than a split.

map <C-e> <plug>NERDTreeTabsToggle<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

let NERDTreeShowBookmarks=1
let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=1
let NERDTreeMouseMode=2
let NERDTreeShowHidden=1
let NERDTreeKeepTreeInNewTab=1
let g:nerdtree_tabs_open_on_gui_startup=0

" -----------------------------------------------------------------------------
"  < Tabularize 插件配置 >
" -----------------------------------------------------------------------------
"
"Tabularize lets you align statements on their equal signs and other characters
"
"Customizations
"
"    <Leader>a= :Tabularize /=<CR>
"    <Leader>a: :Tabularize /:<CR>
"    <Leader>a:: :Tabularize /:\zs<CR>
"    <Leader>a, :Tabularize /,<CR>
"    <Leader>a<Bar> :Tabularize /<Bar><CR>

nmap <Leader>a& :Tabularize /&<CR>
vmap <Leader>a& :Tabularize /&<CR>
nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
nmap <Leader>a=> :Tabularize /=><CR>
vmap <Leader>a=> :Tabularize /=><CR>
nmap <Leader>a: :Tabularize /:<CR>
vmap <Leader>a: :Tabularize /:<CR>
nmap <Leader>a:: :Tabularize /:\zs<CR>
vmap <Leader>a:: :Tabularize /:\zs<CR>
nmap <Leader>a, :Tabularize /,<CR>
vmap <Leader>a, :Tabularize /,<CR>
nmap <Leader>a,, :Tabularize /,\zs<CR>
vmap <Leader>a,, :Tabularize /,\zs<CR>
nmap <Leader>a<Space> :Tabularize /
vmap <Leader>a<Space> :Tabularize /


" -----------------------------------------------------------------------------
"  < quickfix 插件配置 >
" ---------------------------------------------------------------------------"--
":cc                显示详细错误信息 ( :help :cc )
":cp                跳到上一个错误 ( :help :cp )
":cn                跳到下一个错误 ( :help :cn )
":cl                列出所有错误 ( :help :cl )
":cw                如果有错误列表，则打开quickfix窗口 ( :help :cw )
":col               到前一个旧的错误列表 ( :help :col )
":cnew              到后一个较新的错误列表 ( :help :cnew )
nmap <leader>cw :cw 10<cr>

" -----------------------------------------------------------------------------
"  < syntastic 插件配置 >
" ---------------------------------------------------------------------------"--
let g:syntastic_error_symbol='>>'
let g:syntastic_warning_symbol='>'
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0
let g:syntastic_enable_highlighting=1
let g:syntastic_python_checkers=['pyflakes'] " 使用pyflakes,速度比pylint快
"let g:syntastic_javascript_checkers = ['jsl', 'jshint']
"let g:syntastic_html_checkers=['tidy', 'jshint']

let g:syntastic_always_populate_loc_list = 0
let g:syntastic_auto_loc_list = 0
let g:syntastic_loc_list_height = 5

" nnoremap <Leader>ee :Errors<cr>
" nnoremap <Leader>sn :lnext<cr>
" nnoremap <Leader>sp :lprevious<cr>

"
" -----------------------------------------------------------------------------
"  < ctrlp 插件配置 >
" -----------------------------------------------------------------------------
"Ctrlp replaces the Command-T plugin with a 100% viml plugin. It provides an intuitive and fast mechanism to load files from the file system (with regex and fuzzy find), from open buffers, and from recently used files.
"
"QuickStart Launch using <c-p>.

let g:ctrlp_working_path_mode = 'ra'
nnoremap <silent> <D-t> :CtrlP<CR>
nnoremap <silent> <D-r> :CtrlPMRU<CR>
let g:ctrlp_custom_ignore = {
            \ 'dir':  '\.git$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$\|\.dll$\|\.pyc$' }

" On Windows use "dir" as fallback command.
if g:iswindows
    let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
elseif executable('ag')
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
elseif executable('ack-grep')
    let s:ctrlp_fallback = 'ack-grep %s --nocolor -f'
elseif executable('ack')
    let s:ctrlp_fallback = 'ack %s --nocolor -f'
else
    let s:ctrlp_fallback = 'find %s -type f'
endif
if exists("g:ctrlp_user_command")
    unlet g:ctrlp_user_command
endif
let g:ctrlp_user_command = {
            \ 'types': {
            \ 1: ['.git', 'cd %s && git ls-files . --cached --exclude-standard --others'],
            \ 2: ['.hg', 'hg --cwd %s locate -I .'],
            \ },
            \ 'fallback': s:ctrlp_fallback
            \ }

"ctrlp-funky 设置 without ctags
" CtrlP extensions
let g:ctrlp_extensions = ['funky']

"funky
nnoremap <Leader>fu :CtrlPFunky<Cr>

" -----------------------------------------------------------------------------
"  < Tagbar 插件配置 >
" -----------------------------------------------------------------------------
" 相对 TagList 能更好的支持面向对象

" 常规模式下输入 tb 调用插件，如果有打开 TagList 窗口则先将其关闭
nmap <leader>tb :TagbarToggle<CR>:TlistClose<CR>

let g:tagbar_width=30                       "设置窗口宽度
" let g:tagbar_left=1                         "在左侧窗口中显示

" -----------------------------------------------------------------------------
"  < vim-airline 插件配置 >
" -----------------------------------------------------------------------------
" Set configuration options for the statusline plugin vim-airline.
" Use the powerline theme and optionally enable powerline symbols.
" To use the symbols , , , , , , and .in the statusline
" segments add the following to your .vimrc.before.local file:
"   let g:airline_powerline_fonts=1
" If the previous symbols do not render for you then install a
" powerline enabled font.

" See `:echo g:airline_theme_map` for some more choices
" Default in terminal vim is 'dark'
"
if !exists('g:airline_theme')
    let g:airline_theme = 'molokai'
endif
if !exists('g:airline_powerline_fonts')
    " Use the default set of separators with a few customizations

    let g:airline_left_sep='›'  " Slightly fancier than '>'
    let g:airline_right_sep='‹' " Slightly fancier than '<'
endif

" -----------------------------------------------------------------------------
"  < vim-indent-guides 插件配置 >
" -----------------------------------------------------------------------------
" 自动启动  <leader>ig
let g:indent_guides_enable_on_vim_startup = 1
" 自定义颜色
let g:indent_guides_auto_colors = 1
"autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=red   ctermbg=3
"autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=green ctermbg=4
" 终端
"hi IndentGuidesOdd  ctermbg=black
"hi IndentGuidesEven ctermbg=darkgrey

" -----------------------------------------------------------------------------
"  < ctrlsf 插件配置 >
" -----------------------------------------------------------------------------
let g:ctrlsf_ackprg = 'ag'
"
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>n <Plug>CtrlSFCwordPath
nmap     <C-F>p <Plug>CtrlSFPwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>
"
" -----------------------------------------------------------------------------
"  < multi_cursor 插件配置 >
" -----------------------------------------------------------------------------
let g:multi_cursor_use_default_mapping=0

" Default mapping
let g:multi_cursor_start_word_key      = '<C-n>'
let g:multi_cursor_select_all_word_key = '<A-n>'
let g:multi_cursor_start_key           = 'g<C-n>'
let g:multi_cursor_select_all_key      = 'g<A-n>'
let g:multi_cursor_next_key            = '<C-n>'
let g:multi_cursor_prev_key            = '<C-p>'
let g:multi_cursor_skip_key            = '<C-x>'
let g:multi_cursor_quit_key            = '<Esc>'

nnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
vnoremap <silent> <M-j> :MultipleCursorsFind <C-R>/<CR>
" -----------------------------------------------------------------------------
"  < MarkDown Preview 插件配置 >
" -----------------------------------------------------------------------------
nmap <silent> <F8> <Plug>MarkdownPreview        " for normal mode
imap <silent> <F8> <Plug>MarkdownPreview        " for insert mode
nmap <silent> <F9> <Plug>MarkdownPreviewStop    " for normal mode
imap <silent> <F9> <Plug>MarkdownPreviewStop    " for insert mode

let g:mkdp_path_to_chrome = 'firefox'
" -----------------------------------------------------------------------------
"  < Doxygen Toolkit 插件配置 >
" -----------------------------------------------------------------------------
let g:DoxygenToolkit_authorName="Bob Li, oxox0@qq.com"
let g:DoxygenToolkit_briefTag_funcName="yes"
let g:doxygen_enhanced_color=1
map <leader>doa :DoxAuthor<CR>
map <leader>dox :Dox<CR>
map <leader>dol :DoxLic<CR>
map <leader>dob :DoxBlock<CR>
" -----------------------------------------------------------------------------
"  < ultisnips  插件配置 >
" -----------------------------------------------------------------------------
let g:UltiSnipsExpandTrigger = "<tab>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"

" =============================================================================
"                          << 以下为常用工具配置 >>
" =============================================================================


" -----------------------------------------------------------------------------
"  < YouCompleteMe 共具配置 >
" ----------------o-------------------------------------------------------------
" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'
"YouCompleteMe 通过这个cm_global_ycm_extra_conf来获得补全规则，可以如下指定，也可以每次放置在工作目录
let g:ycm_global_ycm_extra_conf=plugPath.'YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
set runtimepath+=plugPath.'YouCompleteMe'
let g:ycm_server_python_interpreter = "python"

set completeopt-=preview
let g:ycm_confirm_extra_conf=0
let g:ycm_error_symbol = '>>'
let g:ycm_warning_symbol = '>*'
nnoremap <leader>gl :YcmCompleter GoToDeclaration<CR>
nnoremap <leader>gf :YcmCompleter GoToDefinition<CR>
nnoremap <leader>gg :YcmCompleter GoToDefinitionElseDeclaration<CR>
nmap <F4> :YcmDiags<CR>
" -----------------------------------------------------------------------------
"  < cscope 工具配置 >
" -----------------------------------------------------------------------------
" 命令启用cscope -Rbq
"-R: 在生成索引文件时，搜索子目录树中的代码
"-b: 只生成索引文件，不进入cscope的界面
"-q: 生成cscope.in.out和cscope.po.out文件，加快cscope的索引速度
"-k: 在生成索引文件时，不搜索/usr/include目录
"-i: 如果保存文件列表的文件名不是cscope.files时，需要加此选项告诉cscope到哪儿去找源文件列表。可以使用“-”，表示由标准输入获得文件列表。
"-I dir: 在-I选项指出的目录中查找头文件
"-u: 扫描所有文件，重新生成交叉索引文件
"-C: 在搜索时忽略大小写
"-P path: 在以相对路径表示的文件前加上的path，这样，你不用切换到你数据库文件所在的目录也可以使用它了。 用Cscope自己的话说 - "你可以把它当做是超过频的ctags"
"使用
"s: 查找C语言符号，即查找函数名、宏、枚举值等出现的地方
"g: 查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
"d: 查找本函数调用的函数
"c: 查找调用本函数的函数
"t: 查找指定的字符串
"e: 查找egrep模式，相当于egrep功能，但查找速度快多了
"f: 查找并打开文件，类似vim的find功能
"i: 查找包含本文件的文
if has("cscope")
    "设定可以使用 quickfix 窗口来查看 cscope 结果
    set cscopequickfix=s-,c-,d-,i-,t-,e-
    "使支持用 Ctrl+]  和 Ctrl+t 快捷键在代码间跳转
    set cscopetag
    "如果你想反向搜索顺序设置为1
    set csto=0
    "在当前目录中添加任何数据库
    if filereadable("cscope.out")
        "出现重复加载就注销掉
        cs add cscope.out
        "否则添加数据库环境中所指出的
    elseif $CSCOPE_DB != ""
        cs add $CSCOPE_DB
    endif
    set cscopeverbose
    "快捷键设置
    nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
    nmap <C-\>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
    nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>
    nmap <C-\><space> :cs find<space>
endif

" -----------------------------------------------------------------------------
"  < ctags 工具配置 >
" -----------------------------------------------------------------------------
" 对浏览代码非常的方便,可以在函数,变量之间跳转等
" ctags -R 命令配置
set tags=./tags;/,~/.vimtags                            "向上级目录递归查找tags文件（好像只有在Windows下才有用）

" Make tags placed in .git/tags file available in all levels of a repository
let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
if gitroot != ''
    let &tags = &tags . ',' . gitroot . '/.git/tags'
endif
" -----------------------------------------------------------------------------
"  < gvimfullscreen 工具配置 > 请确保已安装了工具
" -----------------------------------------------------------------------------
" 用于 Windows Gvim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
if (g:iswindows && g:isGUI)
    nmap <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" -----------------------------------------------------------------------------
"  < vimtweak 工具配置 > 请确保以已装了工具
" -----------------------------------------------------------------------------
" 这里只用于窗口透明与置顶
" 常规模式下 Ctrl + Up（上方向键） 增加不透明度，Ctrl + Down（下方向键） 减少不透明度，<Leader>t 窗口置顶与否切换
if (g:iswindows && g:isGUI)
    let g:Current_Alpha = 255
    let g:Top_Most = 0
    func! Alpha_add()
        let g:Current_Alpha = g:Current_Alpha + 10
        if g:Current_Alpha > 255
            let g:Current_Alpha = 255
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Alpha_sub()
        let g:Current_Alpha = g:Current_Alpha - 10
        if g:Current_Alpha < 155
            let g:Current_Alpha = 155
        endif
        call libcallnr("vimtweak.dll","SetAlpha",g:Current_Alpha)
    endfunc
    func! Top_window()
        if  g:Top_Most == 0
            call libcallnr("vimtweak.dll","EnableTopMost",1)
            let g:Top_Most = 1
        else
            call libcallnr("vimtweak.dll","EnableTopMost",0)
            let g:Top_Most = 0
        endif
    endfunc

    "快捷键设置
    nmap <c-up> :call Alpha_add()<CR>
    nmap <c-down> :call Alpha_sub()<CR>
    nmap <leader>t :call Top_window()<CR>
endif

" =============================================================================
"                          << 以下为常用自动命令配置 >>
" =============================================================================

" 自动切换目录为当前编辑文件所在目录
"au BufRead,BufNewFile,BufEnter * cd %:p:h

" endif
