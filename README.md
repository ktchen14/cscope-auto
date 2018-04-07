# cscope-auto

cscope-auto ensures that a single cscope connection is available to the best
cscope database for the current buffer. If your cscope databases aren't named
`cscope.out` then configure:

```vim
let g:cscope_auto_database_name = '.cscope'
```

Or if you have cscope databases with different names then do:

```vim
let g:cscope_auto_database_name = ['.cscope', 'cscope.out']
```

In addition cscope-auto automatically reestablishes the existing cscope
connection when you change `&ignorecase` or when the cscope database has been
updated.

## Installation

Use your favorite plugin manager. Using [vim-plug](https://github.com/junegunn/vim-plug):

```vim
Plug 'ktchen14/cscope-auto'
```

## Copyright and License

Copyright (c) 2017 Kaiting Chen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
