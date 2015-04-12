" dirdo - execute Vim command for each file recursively under directories
" Version: 0.1.0
" Copyright (C) 2015 deris <deris0126@gmail.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

let s:save_cpo = &cpo
set cpo&vim

" Public API {{{1
function! dirdo#define(...)
  let s:dir_list = s:get_dir_list(a:000)
endfunction

function! dirdo#add(...)
  let s:dir_list = get(s:, 'dir_list', [])
  call extend(s:dir_list, s:get_dir_list(a:000))
endfunction

function! dirdo#print()
  echom string(get(s:, 'dir_list', []))
endfunction

function! dirdo#do(command)
  if !exists('s:dir_list')
    return
  endif

  let file_list = s:filelist_under_dir(filter(s:dir_list, 'isdirectory(v:val)'))

  if empty(file_list)
    return
  endif

  execute 'arglocal ' join(file_list, ' ')
  execute 'argdo ' a:command
endfunction
"}}}

" Private {{{1
function s:get_dir_list(dir_list)
  let dir_list = []
  call extend(dir_list, empty(a:dir_list) ? [getcwd()] : a:dir_list)
  return map(filter(dir_list, 'isdirectory(v:val)'), "fnamemodify(v:val, ':p:h')")
endfunction

function s:filelist_under_dir(dir_list)
  let dir_names = join(map(copy(a:dir_list), "escape(v:val, ',')"), ',')
  let file_list = filter(globpath(dir_names, '/**', 0, 1), 'filereadable(v:val)')
  return uniq(sort(file_list))
endfunction
"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" __END__ "{{{1
" vim: foldmethod=marker
