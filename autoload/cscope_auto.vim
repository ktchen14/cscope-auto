" Maintainer: Kaiting Chen <ktchen14@gmail.com>

let s:database_name = get(g:, 'cscope_auto_database_name', 'cscope.out')

let s:dirsep = fnamemodify(getcwd(), ':p')[-1:]

" Return the nearest cscope database to the path by walking up the directory
" tree and looking for a file named according to cscope_auto_database_name. If
" there is no matching cscope database then return an empty string.
function! cscope_auto#locate_database(path)
  let path = fnamemodify(a:path, ':p:h')

  while !exists('last') || path !=# last
    let file = substitute(path, s:dirsep . '\?$', s:dirsep . s:database_name, '')
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
    execute 'lcd ' . path
  elseif exists(':tcd') && haslocaldir(-1)
    execute 'tcd ' . path
  else
    execute 'cd ' . path
  endif
endfunction

function! cscope_auto#id_list()
  return map(split(execute('cs show'), '\n')[1:], "+matchstr(v:val, '\d\+')")
endfunction

function! cscope_auto#remake(database, ignorecase)
  if a:database ==# get(g:, 'cscope_auto_database', '') &&
        \ a:ignorecase == get(g:, 'cscope_auto_ignorecase', a:ignorecase)
    return
  endif

  if exists('g:cscope_auto_id')
    " Use silent! in case this was killed by the user
    silent! execute 'cscope kill ' . g:cscope_auto_id
    unlet g:cscope_auto_id
    unlet g:cscope_auto_database
    unlet g:cscope_auto_ignorecase
  endif

  if empty(a:database) | return | endif

  let prefix = fnamemodify(a:database, ':h')
  let suffix = a:ignorecase ? ' -C' : ''

  let before = cscope_auto#id_list()
  execute 'cscope add ' . fnameescape(a:database) . ' ' . fnameescape(prefix) . suffix
  let result = cscope_auto#id_list()
  call filter(result, 'index(before, v:val) == -1')
  let g:cscope_auto_id = result[0]

  let g:cscope_auto_database = a:database
  let g:cscope_auto_ignorecase = a:ignorecase
endfunction

function! cscope_auto#switch_buffer(number)
  let name = bufname(a:number)

  if empty(getbufvar(a:number, '&buftype')) && !empty(name)
    let path = name
  else
    let path = getcwd()
  endif

  let database = cscope_auto#locate_database(path)
  return cscope_auto#remake(database, &ignorecase)
endfunction

function! cscope_auto#switch_ignorecase()
  let database = get(g:, 'cscope_auto_database', '')
  return cscope_auto#remake(database, &ignorecase)
endfunction
