" Maintainer: Kaiting Chen <ktchen14@gmail.com>

if exists('g:loaded_cscope_auto')
  finish
endif
let g:loaded_cscope_auto = 1

autocmd VimEnter * call cscope_auto#switch_buffer(bufnr('%'))
autocmd BufEnter * call cscope_auto#switch_buffer(+expand('<abuf>'))

if exists('##DirChanged')
  autocmd DirChanged * call cscope_auto#switch_buffer(bufnr('%'))
endif

" TODO: We should just set the prefix for each cscope connection
set cscoperelative
