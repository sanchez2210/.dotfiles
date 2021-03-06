set encoding=utf-8

" Leader
let mapleader = " "

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

set backspace=2   " backspace deletes like most programs in insert mode
set nobackup
set nowritebackup
set noswapfile
set history=50
set ruler         " show the cursor position all the time
set showcmd       " display incomplete commands
set incsearch     " do incremental searching
set laststatus=2  " Always display the status line
set autowrite     " Automatically :write before running commands

" Easier switching out of insert mode
inoremap jk <ESC>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif

if &term =~ '256color'
  " disable Background Color Erase (BCE) so that color schemes
  " render properly when inside 256-color tmux and GNU screen.
  " see also http://snk.tuxfamily.org/log/vim-256color-bce.html
  set t_ut=
endif

let g:airline_powerline_fonts = 1
"
" Colors and theme options
"
let g:jellybeans_overrides = { 'background': { 'guibg': '050505' } }
colorscheme jellybeans

if exists('+termguicolors')
  let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" Load matchit.vim, but only if the user hasn't installed a newer version.
if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

augroup vimrcEx
  autocmd!

  " When editing a file, always jump to the last known cursor position.
  " Don't do it for commit messages, when the position is invalid, or when
  " inside an event handler (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  " Set syntax highlighting for specific file types
  autocmd BufRead,BufNewFile *.ejs.jst  set filetype=html
  autocmd BufRead,BufNewFile *.axlsx    set filetype=ruby
  autocmd BufRead,BufNewFile *.jst.ejs  set filetype=html
  autocmd BufRead,BufNewFile Appraisals set filetype=ruby
  autocmd BufRead,BufNewFile *.md       set filetype=markdown
  autocmd BufRead,BufNewFile .{jscs,jshint,eslint}rc set filetype=json
augroup END

" ALE linting events
augroup ale
  autocmd!

  if g:has_async
    let g:ale_lint_on_text_changed = 0
    let g:ale_set_signs = 0 " This avoids ale signs to overwrite gitgutter's
  else
    echoerr "The thoughtbot dotfiles require NeoVim or Vim 8"
  endif
augroup END

let g:ale_linters = { 'ruby': ['standardrb'] }
let g:airline#extensions#ale#enabled = 1

" When the type of shell script is /bin/sh, assume a POSIX-compatible
" shell for syntax highlighting purposes.
let g:is_posix = 1

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set shiftround
set expandtab

" Display extra whitespace
set list listchars=tab:»·,trail:·,nbsp:·                 

" Use one space, not two, after punctuation.
set nojoinspaces

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in FZF for listing files. Lightning fast and respects .gitignore
  let $FZF_DEFAULT_COMMAND = 'ag --ignore .git --hidden -g ""'

  if !exists(":Ag")
    nnoremap \ :Ag<SPACE>
  endif
endif

" Make it obvious where 80 characters es
set textwidth=80
set colorcolumn=81

" Numbers
set number
set numberwidth=4

" Tab completion
" will insert tab at beginning of line,
" will use completion if not at beginning
set wildmode=list:longest,list:full
function! InsertTabWrapper()
  let col = col('.') - 1
  if !col || getline('.')[col - 1] !~ '\k'
    return "\<Tab>"
  else
    return "\<C-p>"
  endif
endfunction
inoremap <Tab> <C-r>=InsertTabWrapper()<CR>
inoremap <S-Tab> <C-n>

" Switch between the last two files
nnoremap <Leader><Leader> <c-^>

" Get off my lawn
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

" vim-test mappings
nnoremap <silent> <Leader>t :TestFile<CR>
nnoremap <silent> <Leader>s :TestNearest<CR>
nnoremap <silent> <Leader>l :TestLast<CR>
nnoremap <silent> <Leader>a :TestSuite<CR>
nnoremap <silent> <Leader>gt :TestVisit<CR>

" Treat <li> and <p> tags like the block tags they are
let g:html_indent_tags = 'li\|p'

" Open new split panes to right and bottom, which feels more natural
set splitbelow
set splitright

" Quicker window movement
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Move between linting errors
nnoremap ]r :ALENextWrap<CR>
nnoremap [r :ALEPreviousWrap<CR>

" https://github.com/bronson/vim-trailing-whitespace
" highlight eol whitespace, http://vim.wikia.com/wiki/highlight_unwanted_spaces
highlight default extrawhitespace ctermbg=darkred guibg=darkred
autocmd colorscheme * highlight default extrawhitespace ctermbg=darkred guibg=darkred
autocmd bufread,bufnew * match extrawhitespace /\\\@<![\u3000[:space:]]\+$/

" the above flashes annoyingly while typing, be calmer in insert mode df asdfa
autocmd insertleave * match extrawhitespace /\\\@<![\u3000[:space:]]\+$/
autocmd insertenter * match extrawhitespace /\\\@<![\u3000[:space:]]\+\%#\@<!$/

" support for meta key
let char='a'
while char <= 'z'
  exec "set <A-".char.">=\e".char
  exec "imap \e".char." <A-".char.">"
  let char = nr2char(1+char2nr(char))
endw
set ttimeout ttimeoutlen=50

" Emmet
" let g:user_emmet_leader_key='<C-\>'

" Enable mouse mode
set mouse=a

set cursorline

nnoremap <C-p> :Files<CR>
nnoremap <A-p> :History<CR>

" Move lines up and down
nnoremap <M-j> :m .+1<CR>==
nnoremap <M-k> :m .-2<CR>==
inoremap <M-j> <Esc>:m .+1<CR>==gi
inoremap <M-k> <Esc>:m .-2<CR>==gi
vnoremap <M-j> :m '>+1<CR>gv=gv
vnoremap <M-k> :m '<-2<CR>gv=gv

" Auto source .vimrc
autocmd bufwritepost .vimrc source $MYVIMRC

" Test strategy
let test#strategy = 'vimux'
" let test#strategy = 'dispatch'
" let test#strategy = 'dispatch_background'
" let test#strategy = 'vimterminal'
let g:VimuxOrientation = 'h'

let g:airline_section_b = ''

:nnoremap <F8> :setl noai nocin nosi inde=<CR>

" HOTKEYS

" vim-rspec
" map <leader>jra :call RunAllSpecs()<CR>
" map <leader>jrf :call RunCurrentSpecFile()<CR>
" map <leader>jrn :call RunNearestSpec()<CR>
" map <leader>jrl :call RunLastSpec()<CR>
" map <leader>jr! :call RunLastFailure()<CR>

" map <leader>eir ogem "rspec-core", :github => "rspec/rspec-core"<CR>gem "rspec-expectations", :github => "rspec/rspec-expectations"<CR>gem "rspec-mocks", :github => "rspec/rspec-mocks"<CR>gem "rspec-support", :github => "rspec/rspec-support"<CR><ESC>

map <leader>eid orequire 'pry'; binding.pry<ESC>

" map <leader>eal :Align & <CR>
" map <leader>eap :Align => <CR>

map <leader>ert :%s/\t/ /g<CR>
map <leader>erq :%s/"/'/g<CR>

map <leader>ogf :tabe Gemfile<CR>
map <leader>ovr :tabe ~/.vimrc<CR>

map <leader>rv :so ~/.vimrc <CR>

map <leader>bi :!bundle install<CR>

map <leader>arp :Ag "^ *p " <CR>
map <leader>apr :Ag "binding.pry " <CR>

" map <leader>ft zfa
" map <leader>uft zR

map <leader>vnp :set nopaste<CR>
map <leader>vp :set paste<CR>

map <leader>hl :set hlsearch<CR>
map <leader>xhl :set nohlsearch<CR>
