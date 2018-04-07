" Maintainer: Kaiting Chen <ktchen14@gmail.com>

if exists('g:loaded_cscope_auto')
  finish
endif
let g:loaded_cscope_auto = 1

augroup cscope_auto
  autocmd!

  " BufEnter fires *after* entering a buffer so bufnr('%') should be the same
  " as +expand('<abuf>')
  autocmd VimEnter,BufEnter * call cscope_auto#switch_buffer(bufnr('%'))

  " The buffer file can change without a BufEnter from the :file or :saveas
  " commands. We can detect this with BufFilePost (though this event will fire
  " whether or not the buffer name actually changes).
  autocmd BufFilePost * call cscope_auto#switch_buffer(+expand('<abuf>'))

  " The buffer file can change without a BufEnter or BufFilePost when saving
  " an unnamed buffer. We can detect this with BufWritePost (though this event
  " will fire whether or not the buffer name actually changes).
  autocmd BufWritePost * call cscope_auto#switch_buffer(+expand('<abuf>'))

  if exists('##DirChanged')
    autocmd DirChanged * call cscope_auto#switch_buffer(bufnr('%'))
  endif

  " Before each :cscope command is executed ensure that the active cscope
  " connection is up to date
  autocmd QuickFixCmdPre cscope call cscope_auto#retime()

  " If the cscope database is added with an absolute prefix then any finds
  " using it return absolute file paths. When the quickfix list is populated
  " an unlisted buffer is created for each file with this absolute file path
  " as the buffer name. The filenames displayed in the quickfix window are
  " generated from these buffer names.
  "
  " To display relative paths in the quickfix window we can fire a directory
  " change event (:lcd, :tcd, :cd). On any of these vim will rename each
  " buffer relative to the current directory if possible. This will in turn
  " update the file paths used in the quickfix window. Note that this has to
  " happen before the quickfix window is populated (before the BufReadPost
  " quickfix).
  autocmd QuickFixCmdPost cscope call cscope_auto#cd('.')

  " OptionSet was introduced in Vim 7.4.786
  if exists('##OptionSet')
    autocmd OptionSet ignorecase call cscope_auto#switch_ignorecase()
  endif
augroup end
