let s:sections = ['a','b','c','gutter','x','y','z']

function! s:override_left_only(section1, section2)
  let w:airline_section_a = a:section1
  let w:airline_section_b = a:section2
  let w:airline_section_c = ''
  let w:airline_left_only = 1
endfunction

function! airline#extensions#apply_window_overrides()
  unlet! w:airline_left_only
  for section in s:sections
    unlet! w:airline_section_{section}
  endfor

  if &buftype == 'quickfix'
    let w:airline_section_a = 'Quickfix'
    let w:airline_section_b = ''
    let w:airline_section_c = ''
    let w:airline_section_x = ''
  elseif &buftype == 'help'
    call s:override_left_only('Help', '%f')
    let w:airline_section_gutter = ' '
  endif

  if &previewwindow
    let w:airline_section_a = 'Preview'
    let w:airline_section_b = ''
    let w:airline_section_c = bufname(winbufnr(winnr()))
  endif

  if &ft == 'netrw'
    call s:override_left_only('netrw', '%f')
  elseif &ft == 'unite'
    call s:override_left_only('Unite', '%{unite#get_status_string()}')
  elseif &ft == 'nerdtree'
    call s:override_left_only('NERD', '')
  elseif &ft == 'undotree'
    call s:override_left_only('undotree', '')
  elseif &ft == 'gundo'
    call s:override_left_only('Gundo', '')
  elseif &ft == 'diff'
    call s:override_left_only('diff', '')
  elseif &ft == 'tagbar'
    call s:override_left_only('Tagbar', '')
  elseif &ft == 'vimshell'
    call s:override_left_only('vimshell', '%{vimshell#get_status_string()}')
  elseif &ft == 'vimfiler'
    call s:override_left_only('vimfiler', '%{vimfiler#get_status_string()}')
  elseif &ft == 'minibufexpl'
    call s:override_left_only('MiniBufExplorer', '')
  endif

  for Fn in g:airline_window_override_funcrefs
    call Fn()
  endfor
endfunction

function! airline#extensions#load()
  let g:unite_force_overwrite_statusline = 0
  let g:vimfiler_force_overwrite_statusline = 0

  if get(g:, 'loaded_ctrlp', 0)
    call airline#extensions#ctrlp#load_ctrlp_hi()
    let g:ctrlp_status_func = {
          \ 'main': 'airline#extensions#ctrlp#ctrlp_airline',
          \ 'prog': 'airline#extensions#ctrlp#ctrlp_airline_status',
          \ }
  endif

  if g:airline_enable_bufferline && get(g:, 'loaded_bufferline', 0)
    highlight AlBl_active gui=bold cterm=bold term=bold
    highlight link AlBl_inactive Al6
    let g:bufferline_inactive_highlight = 'AlBl_inactive'
    let g:bufferline_active_highlight = 'AlBl_active'
    let g:bufferline_active_buffer_left = ''
    let g:bufferline_active_buffer_right = ''
    let g:bufferline_separator = ' '
  endif
endfunction

