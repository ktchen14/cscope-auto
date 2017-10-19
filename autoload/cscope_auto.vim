" Maintainer: Kaiting Chen <ktchen14@gmail.com>

let s:dirsep = fnamemodify(getcwd(), ':p')[-1:]

" Return the nearest cscope database to the path by walking up the directory
" tree and looking for a file named according to cscope_auto_database_name. If
" there is no matching cscope database then return an empty string.
"
" Consider just using findfile() if we can find a way to easily work around
" &suffixesadd.
function! cscope_auto#locate_database(path)
  let path = fnamemodify(a:path, ':p:h')
  let database_name = get(g:, 'cscope_auto_database_name', 'cscope.out')

  while !exists('last') || path !=# last
    let file = substitute(path, s:dirsep . '\?$', s:dirsep . database_name, '')
    if filereadable(file)
      return file
    endif
    let last = path
    let path = fnamemodify(path, ':h')
  endwhile
  return ''
endfunction

" Use the correct scope (window, tab, or global) to cd into path. Whether each
" window or tab has a local directory should be unchanged.
function! cscope_auto#cd(path)
  let path = fnameescape(a:path)
  if haslocaldir()
    let cd = 'lcd'
  elseif exists(':tcd') && haslocaldir(-1)
    let cd = 'tcd'
  else
    let cd = 'cd'
  endif
  execute cd fnameescape(path)
endfunction

function! cscope_auto#id_list()
  return map(split(execute('cs show'), '\n')[1:], "+matchstr(v:val, '\d\+')")
endfunction

function! cscope_auto#rewire(database)
  if exists('s:cscope_auto_id')
    " Use silent! in case this was killed by the user
    silent! execute 'cscope kill' s:cscope_auto_id
    unlet s:cscope_auto_id
    unlet s:cscope_auto_database
    unlet s:cscope_auto_time
    unlet s:cscope_auto_ignorecase
  endif

  if empty(a:database) | return | endif

  let prefix = fnamemodify(a:database, ':h')
  let suffix = &ignorecase ? '-C' : ''

  let before = cscope_auto#id_list()
  execute 'cscope add' fnameescape(a:database) fnameescape(prefix) suffix
  let result = cscope_auto#id_list()
  call filter(result, 'index(before, v:val) == -1')
  let s:cscope_auto_id = result[0]

  let s:cscope_auto_database = a:database
  let s:cscope_auto_time = getftime(a:database)
  let s:cscope_auto_ignorecase = &ignorecase
endfunction

function! cscope_auto#switch_buffer(number)
  let name = bufname(a:number)

  if empty(getbufvar(a:number, '&buftype')) && !empty(name)
    let path = name
  else
    let path = getcwd()
  endif

  let database = cscope_auto#locate_database(path)
  if database ==# get(s:, 'cscope_auto_database', '')
    return
  endif
  call cscope_auto#rewire(database)
endfunction

function! cscope_auto#retime()
  if !exists('s:cscope_auto_id') | return | endif
  if getftime(s:cscope_auto_database) <= s:cscope_auto_time
    return
  endif
  call cscope_auto#rewire(s:cscope_auto_database)
endfunction

function! cscope_auto#switch_ignorecase()
  if !exists('s:cscope_auto_id') | return | endif
  if &ignorecase == s:cscope_auto_ignorecase
    return
  endif
  call cscope_auto#rewire(s:cscope_auto_database)
endfunction
