let s:save_cpo = &cpo
set cpo&vim

let g:unite#sources#emoji#enable_japanese_description = get(g:, 'unite#sources#emoji#enable_japanese_description', 0)
let g:unite#sources#emoji#enable_japanese_description = 1

let s:source = {
            \ 'name' : 'emoji',
            \ 'description' : 'Search GitHub emojis',
            \ 'default_action' : {'common' : 'insert'},
            \ }

function! s:has_vim_emoji()
    if !exists('s:exists_vim_emoji')
        try
            call emoji#available()
            let s:exists_vim_emoji = 1
        catch
            let s:exists_vim_emoji = 0
        endtry
    endif
    return s:exists_vim_emoji
endfunction

function! s:emojis()
    if exists('s:cache')
        return s:cache
    endif

    let s:cache = items(emoji#data#dict())

    return s:cache
endfunction

function! s:error_msg(msg)
    echohl ErrorMsg
    echomsg 'unite-emoji.vim: ' . a:msg
    echohl None
endfunction

function! s:get_description_of(emoji)
    let [name, code] = a:emoji

    let desc = name

    if g:unite#sources#emoji#enable_japanese_description
    endif

    if emoji#available()
        let desc .= ' ' . emoji#for(name)
    endif

    return desc
endfunction

function! s:source.gather_candidates(args, context)
    if !s:has_vim_emoji()
        call s:error_msg('vim-emoji is not installed.  Please install it from https://github.com/junegunn/vim-emoji')
        return []
    endif

    return map(s:emojis(), '{
        \ "word" : s:get_description_of(v:val),
        \ "action__text" : ":" . v:val[0] . ":",
        \ }')
endfunction

function! unite#sources#emoji#define()
    return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
