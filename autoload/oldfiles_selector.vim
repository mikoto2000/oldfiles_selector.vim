function! oldfiles_selector#OpenOldfilesSelector() abort
    """ 呼び出し元のウィンドウ ID を記憶
    let s:caller_window_id = win_getid()

    " 検索文字初期化
    let s:patterns = ""

    """ 新しいバッファを作成
    if bufexists(bufnr('__OLDFILES_SELECTOR_OLDFILES_LIST__'))
        bwipeout! __OLDFILES_SELECTOR_OLDFILES_LIST__
    endif
    silent bo new __OLDFILES_SELECTOR_OLDFILES_LIST__

    "" 先頭行へ移動
    normal gg

    """ バッファリスト用バッファの設定
    setlocal noshowcmd
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal nowrap
    setlocal nonumber

    " カーソル設定保存
    redir => cursor_highlight_line
    silent highlight Cursor
    redir END
    let s:cursor_highlight = get(split(cursor_highlight_line, "xxx "), 1)
    let s:cursorcolumn=&cursorcolumn
    let s:cursorline=&cursorline
    let s:guicursor=&guicursor

    " カーソル復元用 autocmd
    augroup oldfiles_selector
        autocmd!
        autocmd BufLeave <buffer> execute "highlight Cursor " . s:cursor_highlight
        autocmd BufLeave <buffer> execute "set guicursor=" . s:guicursor
        autocmd BufLeave <buffer> let &cursorcolumn = s:cursorcolumn
        autocmd BufLeave <buffer> let &cursorline = s:cursorline
    augroup END

    " カーソル設定
    highlight Cursor gui=NONE guifg=NONE guibg=NONE guisp=NONE
    set guicursor=i:iCursor
    set nocursorcolumn
    set cursorline

    " カーソルを消す
    set filetype=oldfile_selector

    """ 選択したバッファに移動
    silent map <buffer> <Return> :call oldfiles_selector#OpenFile()<Return>
    silent inoremap <buffer> <C-l> <Esc>:call oldfiles_selector#OpenFile()<Return>

    """ バッファリストを閉じる
    silent inoremap <silent> <buffer> q <ESC>:call oldfiles_selector#CloseOldfilesSelector()<Return>
    silent noremap <silent> <buffer> q <ESC>:call oldfiles_selector#CloseOldfilesSelector()<Return>


    " パターン文字削除
    silent inoremap <silent> <buffer> <BS> <Esc>:call oldfiles_selector#DelChar()<Return>

    " 移動
    silent inoremap <buffer> <C-p> <Up>
    silent inoremap <buffer> <C-n> <Down>

    " 絞り込み用バッファ初期化
    silent % delete _

    """ 変数 s:oldfiles_list に ``:oldfiles`` の結果を格納
    let s:oldfiles_list=""
    redir => s:oldfiles_list
    silent oldfiles
    redir END

    """ 検索モード設定
    " インサートモードにしたうえで、入力無効にする
    augroup insert_disable
        autocmd!
        autocmd InsertCharPre <buffer> call oldfiles_selector#AddChar()
        autocmd TextChangedI <buffer> call oldfiles_selector#UpdateBuffer()
    augroup END
    inoremap <buffer> <Enter> <nop>

    call oldfiles_selector#UpdateBuffer()

    startinsert

endfunction

function! oldfiles_selector#UpdateBuffer()
    silent % delete _

    """ __OLDFILES_SELECTOR_OLDFILES_LIST__ に ``:oldfiles`` の結果を表示
    call setline(1, v:oldfiles)

    " pattern の抽出
    if (s:patterns != "")
        " 半角スペースで区切り、 AND で絞り込む
        for pattern in split(s:patterns, ' ')
            silent execute "v/" . pattern . "/d"
        endfor
    endif
    normal gg
    echo "pattern > " . s:patterns
endfunction

""" 何かを入力しようとしたら、必ずプロンプトの末尾に文字が追加されるようにする
function! oldfiles_selector#AddChar()
    let s:patterns = s:patterns . v:char
endfunction

""" プロンプト末尾の文字を削除
function! oldfiles_selector#DelChar()
    let s:patterns = s:patterns[0:-2]
    call oldfiles_selector#UpdateBuffer()
    startinsert
endfunction

function! oldfiles_selector#CloseOldfilesSelector() abort
    """ バッファリストを閉じる
    :bwipeout!

    """ 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(s:caller_window_id)
endfunction

function! oldfiles_selector#OpenFile() abort
    let file_path = getline(line('.'))
    :bwipeout!

    """ 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(s:caller_window_id)

    """ バッファを開く
    execute ":e " . file_path
endfunction

