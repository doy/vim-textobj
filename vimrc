" vim:foldmethod=marker commentstring="%s
" based on Eidolos's .vimrc, at http://sartak.katron.org/vimrc

" General options {{{
" Miscellaneous {{{
" fuck vi! long live vim!
set nocompatible

" indentation FTW.. also plugins FTW! heh
filetype indent plugin on

" automatically flush to disk when using :make, etc.
set autowrite

" Gentoo disables modelines by default
set modeline
"}}}
" Display {{{
" color!
syntax on

" lines, cols in status line
set ruler

" current mode in status line
set showmode

" display the number of (characters|lines) in visual mode, also cur command
set showcmd

" a - terse messages (like [+] instead of [Modified]
" t - truncate file names
" I - no intro message when starting vim fileless
set shortmess=atI

" no extra status lines
set laststatus=0

" display as much of the last line as possible if it's really long
" also display unprintable characters as hex
set display+=lastline,uhex

" give three lines of context when moving the cursor around
set scrolloff=3

" don't redraw the screen during macros etc (NetHack's runmode:teleport)
set lazyredraw

" highlight all matches, we'll see if this works with a different hilight
set hlsearch

" highlight matching parens for .2s
set showmatch
set matchtime=2

" threshold for reporting number of lines changed
set report=0

" highlight advanced perl vars inside strings
let perl_extended_vars=1

" POD!
let perl_include_pod=1

" I generally don't want to have to space through things.. :)
set nomore

" tab completion stuff for the command line
set wildmode=longest,list,full

" word wrapping
set linebreak
"}}}
" Improve power of commands {{{
" backspace over autoindent, end of line (to join lines), and preexisting test
set backspace=indent,eol,start

" add the dictionary to tab completion
set dictionary=/usr/share/dict/words
set complete+=k

" tab completion in ex mode
set wildmenu

" when doing tab completion, ignore files with any of the following extensions
set wildignore+=.log,.out,.o

" remember lotsa fun stuff
set viminfo=!,'1000,f1,/1000,:1000,<1000,@1000,h,n~/.viminfo

" add : as a file-name character (mostly for Perl's mod::ules)
set isfname+=:
"}}}
" Make vim less whiny {{{
" :bn with a change in the current buffer? no prob!
set hidden

" no bells whatsoever
set vb t_vb=

" if you :q with changes it asks you if you want to continue or not
set confirm

" 50 milliseconds for escape timeout instead of 1000
set ttimeoutlen=50
"}}}
" Indentation {{{
" normal sized tabs!
set tabstop=8

" set to what i like (see #2 in :help tabstop)
set shiftwidth=4

" if it looks like a tab, we can delete it like a tab
set softtabstop=4

" no tabs! spaces only..
set expandtab

" < and > will hit indentation levels instead of always -4/+4
set shiftround

" new line has indentation equal to previous line
set autoindent

" braces affect autoindentation
set smartindent

" figure out indent when ; is pressed
set cinkeys+=;

" align break with case in a switch
set cinoptions+=b1
"}}}
" Folding {{{
" fold only when I ask for it damnit!
set foldmethod=marker

" use my custom fold display function (see bottom)
set foldtext=Base_foldtext()
"}}}
"}}}

" Colors {{{
colorscheme peachpuff
" word completion menu {{{
highlight Pmenu      ctermfg=grey  ctermbg=darkblue
highlight PmenuSel   ctermfg=red   ctermbg=darkblue
highlight PmenuSbar  ctermbg=cyan
highlight PmenuThumb ctermfg=red

highlight WildMenu ctermfg=grey ctermbg=darkblue
"}}}
" folding {{{
highlight Folded     ctermbg=black ctermfg=darkgreen
"}}}
" hlsearch {{{
highlight Search NONE ctermfg=red
"}}}
"}}}

" Autocommands {{{
" When editing a file, always jump to the last cursor position {{{
autocmd BufReadPost *
\  if line("'\"") > 0 && line("'\"") <= line("$") |
\    exe "normal g`\"" |
\  endif
"}}}
" Skeletons {{{
autocmd BufNewFile *.pl     silent 0read ~/.vim/skeletons/perl | normal Gdd
autocmd BufNewFile *.cpp    silent 0read ~/.vim/skeletons/cpp  | normal Gddk
autocmd BufNewFile *.c      silent 0read ~/.vim/skeletons/c    | normal Gddk
autocmd BufNewFile *.tex    silent 0read ~/.vim/skeletons/tex  | normal Gddk
autocmd BufNewFile Makefile silent 0read ~/.vim/skeletons/make | normal $
" }}}
" Filetypes for when detection sucks {{{
autocmd BufNewFile,BufReadPost *.tex silent set filetype=tex 
" }}}
" Auto +x {{{
au BufWritePost *.sh !chmod +x %
au BufWritePost *.pl !chmod +x %
"}}}
" Perl :make does a syntax check {{{
autocmd FileType perl setlocal makeprg=$VIMRUNTIME/tools/efm_perl.pl\ -c\ %\ $*
autocmd FileType perl setlocal errorformat=%f:%l:%m
autocmd FileType perl setlocal keywordprg=perldoc\ -f
"}}}
" Latex :make converts to pdf {{{
autocmd FileType tex setlocal makeprg=~/bin/latexpdf\ --show\ %
" }}}
" Set up custom folding {{{
autocmd FileType tex set foldtext=Latex_foldtext()
" }}}
"}}}

" Insert-mode remappings/abbreviations {{{
" Arrow keys, etc {{{
imap <up> <C-o>gk
imap <down> <C-o>gj
imap <home> <C-o>g<home>
imap <end> <C-o>g<end>
" }}}
" Hit <C-a> in insert mode after a bad paste (thanks absolon) {{{
inoremap <silent> <C-a> <ESC>u:set paste<CR>.:set nopaste<CR>gi
"}}}
" Normal-mode remappings {{{
" have Y behave analogously to D rather than to dd
nmap Y y$

nnoremap \\ \
nmap \/ :nohl<CR>
nmap \s :syntax sync fromstart<CR>
autocmd FileType help nnoremap <CR> <C-]>
autocmd FileType help nnoremap <BS> <C-T>

" damnit cbus, you've won me over
vnoremap < <gv
vnoremap > >gv
" Make the tab key useful {{{
function TabWrapper()
  if strpart(getline('.'), 0, col('.')-1) =~ '^\s*$'
    return "\<Tab>"
  elseif exists('&omnifunc') && &omnifunc != ''
    return "\<C-X>\<C-N>"
  else
    return "\<C-N>"
  endif
endfunction
imap <Tab> <C-R>=TabWrapper()<CR>
"}}}
" Painless spell checking (F11) {{{
function s:spell()
    if !exists("s:spell_check") || s:spell_check == 0
        echo "Spell check on"
        let s:spell_check = 1
        setlocal spell spelllang=en_us
    else
        echo "Spell check off"
        let s:spell_check = 0
        setlocal spell spelllang=
    endif
endfunction
map <F11> :call <SID>spell()<CR>
imap <F11> <C-o>:<BS>call <SID>spell()<CR>
"}}}
" Arrow keys, etc, again {{{
map <up> gk
map <down> gj
map <home> g<home>
map <end> g<end>
" }}}
"}}}
" }}}

" Plugin settings {{{
" Enhanced Commentify {{{
let g:EnhCommentifyBindInInsert = 'No'
let g:EnhCommentifyRespectIndent = 'Yes'
" }}}
" Rainbow {{{
let g:rainbow = 1
let g:rainbow_paren = 1
let g:rainbow_brace = 1
" why is this necessary? shouldn't just putting it in the plugin dir work?
autocmd BufNewFile,BufReadPost * source ~/.vim/plugin/rainbow_paren.vim
" }}}
" Taglist {{{
let s:session_file = './.tlist_session'
let TlistIncWinWidth = 0
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Use_Horiz_Window = 1
let Tlist_Compact_Format = 1
let Tlist_Close_On_Select = 1
let Tlist_Display_Prototype = 1
nnoremap <silent> <F8> :TlistToggle<CR>
" if the current file isn't below the current directory, :. doesn't modify %
if file_readable(s:session_file) && expand("%:.") !~ '^/'
    autocmd VimEnter * TlistDebug | exec 'TlistSessionLoad ' . s:session_file
    autocmd VimLeave * call delete(s:session_file) | exec 'TlistSessionSave ' . s:session_file
endif
" }}}
" }}}
" Text objects {{{
" Text object creation {{{
let g:text_object_number = 0
function Textobj(char, callback)
    let g:text_object_number += 1
    function Textobj_{g:text_object_number}(inner, operator, count, callback)
        try
            let pos = getpos('.')
            let [startline, startcol, endline, endcol] = function(a:callback)(a:inner, a:count)
        catch /no-match/
            return
        finally
            call setpos('.', pos)
        endtry
        if startline == endline
            let objlength = endcol - startcol + 1
        else
            let lines = getline(startline + 1, endline - 1)
            let lines = [strpart(getline(startline), startcol - 1)] +
            \           lines +
            \           [strpart(getline(endline), 0, endcol)]
            let objlength = 0
            for line in lines
                let objlength += strlen(line) + 1
            endfor
            let objlength -= 1
        endif
        if endcol == 0
            normal! J
        endif
        call cursor(startline, startcol)
        if startcol > strlen(getline(startline))
            normal! J
        endif
        exe 'normal! '.a:operator.objlength.' '

        if a:operator == 'c'
            normal! l
            startinsert
        elseif a:operator == 'v'
            normal! h
        endif
    endfunction

    let cbname = '"' . substitute(a:callback, '^s:', '<SID>', '') . '"'
    exe 'onoremap <silent>a'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(0, v:operator, v:prevcount, '.cbname.')<CR>'
    exe 'onoremap <silent>i'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(1, v:operator, v:prevcount, '.cbname.')<CR>'
    exe 'xnoremap <silent>a'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(0, "v", v:prevcount, '.cbname.')<CR>'
    exe 'xnoremap <silent>i'.a:char.' <Esc>:call Textobj_'.g:text_object_number.'(1, "v", v:prevcount, '.cbname.')<CR>'
endfunction
" }}}
" Text objects {{{
" / for regex {{{
function Textobj_regex(inner, count)
    let pos = getpos('.')

    let line = strpart(getline(pos[1]), 0, pos[2])
    let lines = getline(1, pos[1] - 1) + [line]
    let linenum = pos[1]
    for line in reverse(lines)
        let objstart = match(line, '.*\zs\\\@<!/') + 1
        if objstart != 0
            break
        endif
        let linenum -= 1
    endfor
    if objstart == 0
        throw 'no-match'
    endif
    let objstart += a:inner
    let objstartline = linenum

    let line = strpart(getline(pos[1]), pos[2] - 1)
    let lines = [line] + getline(pos[1] + 1, line('$'))
    let linenum = pos[1]
    for line in lines
        let objend = match(line, '\\\@<!/') + 1
        if objend != 0
            if linenum == pos[1]
                " have to account for the possibility of a split escape
                " sequence
                if objend == 1
                    if getline(pos[1])[pos[2] - 2] == '\'
                        let objend = match(line, '\\\@<!/', 1) + 1
                        if objend == 0
                            let linenum += 1
                            continue
                        endif
                    else
                        " if we're sitting on a /, don't do anything, since it's
                        " impossible to know which direction to look
                        throw 'no-match'
                    endif
                endif
                let objend += pos[2] - 1
            endif
            break
        endif
        let linenum += 1
    endfor
    if objend == 0
        throw 'no-match'
    endif
    let objend -= a:inner
    let objendline = linenum

    return [objstartline, objstart, objendline, objend]
endfunction
call Textobj('/', 'Textobj_regex')
" }}}
" f for folds {{{
function Textobj_fold(inner, count)
    if foldlevel(line('.')) == 0
        throw 'no-match'
    endif
    exe 'normal! '.a:count.'[z'
    let startline = line('.') + a:inner
    normal! ]z
    let endline = line('.') - a:inner

    return [startline, 1, endline, strlen(getline(endline))]
endfunction
call Textobj('f', 'Textobj_fold')
" }}}
" , for function arguments {{{
function Textobj_arg(inner, count)
    let pos = getpos('.')

    let line = strpart(getline(pos[1]), 0, pos[2])
    let lines = getline(1, pos[1] - 1) + [line]
    let linenum = pos[1]
    for line in reverse(lines)
        let argbegin = matchend(line, '.*\%(,\s*\|(\)') + 1
        if argbegin != 0
            while argbegin > strlen(line)
                let linenum += 1
                let line = getline(linenum)
                let argbegin = matchend(line, '^\s*') + 1
            endwhile
            break
        endif
        let linenum -= 1
    endfor
    if argbegin == 0
        throw 'no-match'
    endif
    let argstartline = linenum

    let line = strpart(getline(pos[1]), pos[2] - 1)
    let lines = [line] + getline(pos[1] + 1, line('$'))
    let linenum = pos[1]
    for line in lines
        let argend = match(line, '\zs.\?\%(,\|)\)') + 1
        if argend != 0
            if linenum == pos[1]
                let argend += pos[2] - 1
            endif
            if argend == 1 && getline(linenum)[argend - 1] == ')'
                let linenum -= 1
                let argend = strlen(getline(linenum))
            endif
            break
        endif
        let linenum += 1
    endfor
    if argend == 0
        throw 'no-match'
    endif
    let argendline = linenum

    if a:inner == 0
        let endline = getline(argendline)
        let startline = getline(argstartline)
        if endline[argend] == ')' && startline[argbegin - 2] != '('
            let argbegin -= 1
            let argbegin = match(strpart(startline, 0, argbegin), '\s*$')
            if argbegin == 0
                let argstartline -= 1
                let startline = getline(argstartline)
                let argbegin = strlen(startline)
            endif
        elseif endline[argend] != ')'
            let argend += 1
            let argend += matchend(strpart(endline, argend), '^\s*')
        endif
        if argend == strlen(endline)
            let argend = 0
            let argendline += 1
        endif
    endif

    return [argstartline, argbegin, argendline, argend]
endfunction
call Textobj(',', 'Textobj_arg')
" }}}
" }}}
" }}}

" Folding {{{
" Base {{{
function Base_foldtext(...)
    " if we're passed in a string, use that as the display, otherwise use the
    " contents of the line at the start of the fold
    if a:0 > 0
        let line = a:1
    else
        let line = getline(v:foldstart)
    endif

    " remove the marker that caused this fold from the display
    let foldmarkers = split(&foldmarker, ',')
    let line = substitute(line, '\V\s\?' . foldmarkers[0] . '\s\?', ' ', '')

    " remove any remaining leading or trailing whitespace
    let line = substitute(line, '^\s*\(.\{-}\)\s*$', '\1', '')

    " align everything, and pad the end of the display with -
    let line = printf('%-' . (63 - v:foldlevel) . 's', line)
    let line = substitute(line, '\%( \)\@<= \%( *$\)\@=', '-', 'g')

    " format the line count
    let nlines = printf('%12s',
    \                   '(' . (v:foldend - v:foldstart + 1) . ' lines) ')

    return '+-' . v:folddashes . ' ' . line . nlines
endfunction
" }}}
" Latex {{{
let s:latex_types = {'thm': 'Theorem', 'cor':  'Corollary',
                   \ 'lem': 'Lemma',   'defn': 'Definition'}
function Latex_foldtext()
    let line = getline(v:foldstart)

    " if we get the start of a theorem, format the display nicely
    " XXX: allow the label to be on the following line
    let matches = matchlist(line,
    \                       '\\begin{\([^}]*\)}.*\\label{\([^}]*\)}')
    if !empty(matches) && has_key(s:latex_types, matches[1])
        return Base_foldtext(s:latex_types[matches[1]] . ": " . matches[2])
    endif

    " otherwise, just strip latex comments from the line
    return Base_foldtext(substitute(line, '\s\?%\s\?', ' ', ''))
endfunction
" }}}
" }}}
