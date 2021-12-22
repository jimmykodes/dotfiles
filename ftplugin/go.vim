setlocal expandtab!

nnoremap <leader>f :GoFmt

let g:go_fmt_autosave = 1
let g:go_fmt_command = 'goimports'
let b:go_fmt_options = {
\ 'goimports': '-local ' .
    \ trim(system('{cd '. shellescape(expand('%:h')) .' && go list -m;}')),
\ }
