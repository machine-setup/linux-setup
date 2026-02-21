" Use Vim defaults instead of old Vi compatibility mode (required for plugins, sane behavior)
set nocompatible

" Enable syntax highlighting
syntax enable

" Case-insensitive search by default...
set ignorecase
" ...but becomes case-sensitive if the search pattern contains uppercase letters
set smartcase

" Show matches while typing the search pattern
set incsearch

" Show absolute line numbers
set number

" Ensure text is never hidden by syntax conceal features (useful for Markdown/JSON/plugins)
set conceallevel=0

" Show partially typed commands in the status area
set showcmd

" Enable enhanced command-line completion menu
set wildmenu
