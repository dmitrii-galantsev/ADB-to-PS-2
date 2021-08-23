let g:ale_linters={'vhdl': ['ghdl']}
let s:path = expand('<sfile>:p:h')
let g:ale_vhdl_ghdl_options = "--std=08 -fsynopsys -frelaxed -P" . s:path . "/include/cute_lib"

