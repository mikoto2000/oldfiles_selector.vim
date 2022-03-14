function oldfiles_selector#OpenOldfilesSelector() abort
    """ 呼び出し元のウィンドウ ID を記憶
    let s:caller_window_id = win_getid()

    """ 変数 oldfiles_list に ``:oldfiles`` の結果を格納
    let oldfiles_list=""
    redir => oldfiles_list
    silent oldfiles
    redir END

    """ 新しいバッファを作成
    if bufexists(bufnr('__OLDFILES_SELECTOR_OLDFILES_LIST__'))
        bwipeout! __OLDFILES_SELECTOR_OLDFILES_LIST__
    endif
    silent bo new __OLDFILES_SELECTOR_OLDFILES_LIST__

    """ __OLDFILES_SELECTOR_OLDFILES_LIST__ に ``:oldfiles`` の結果を表示
    silent put!=oldfiles_list

    """ 先頭と末尾が空行になるのでそれを削除
    normal G"_dd
    normal gg"_dd

    """ 行番号を削除
    silent :%s/^\d*: //g

    """ ウィンドウサイズ調整
    call oldfiles_selector#FitWinCol()

    "" 先頭行へ移動
    normal gg

    """ バッファリスト用バッファの設定
    setlocal noshowcmd
    setlocal noswapfile
    setlocal buftype=nofile
    setlocal bufhidden=delete
    setlocal nobuflisted
    setlocal nomodifiable
    setlocal nowrap
    setlocal nonumber

    """ 選択したバッファに移動
    map <buffer> <Return> :call oldfiles_selector#OpenFile()<Return>

    """ バッファリストを閉じる
    map <buffer> q :call oldfiles_selector#CloseOldfilesSelector()<Return>
endfunction

function oldfiles_selector#CloseOldfilesSelector() abort
    """ バッファリストを閉じる
    :bwipeout!

    """ 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(s:caller_window_id)
endfunction

function oldfiles_selector#OpenFile() abort
    let file_path = getline(line('.'))
    :bwipeout!

    """ 呼び出し元ウィンドウをアクティブにする
    call win_gotoid(s:caller_window_id)

    """ バッファを開く
    execute ":e " . file_path
endfunction

""" ウィンドウサイズ調整
function oldfiles_selector#FitWinCol() abort
    let current_win_height=winheight('%')
    let line_num=line('$')
    if current_win_height - line_num > 0
        execute "normal z" . line_num . "\<Return>"
    endif
endfunction
