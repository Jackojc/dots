declare-user-mode tabs

declare-option str modelinefmt_tabs %opt{modelinefmt}
declare-option str modeline_buflist
declare-option str switch_to_tab
declare-option str tab_separator
set-option global tab_separator "|"

define-command rename-buffer-prompt %{
  prompt -init %sh{ basename "$kak_bufname" } rename: %{
    rename-buffer %val{text}
    refresh-buflist
  }
}

define-command -hidden refresh-buflist %{
  set-option buffer modeline_buflist %sh{
    tabs=""

    eval "set -- $kak_quoted_buflist"
    for buf; do
      if [ "$buf" = "*debug*" ] && [ "$kak_bufname" != "*debug*" ]; then
        continue
      fi

      if [ "$buf" = "$kak_bufname" ]; then
        tabs="$tabs$kak_opt_tab_separator {StatusLineValue}$(basename "$buf"){Default} "
      else
        tabs="$tabs$kak_opt_tab_separator {Default}$(basename "$buf"){Default} "
      fi
    done
    echo "$tabs"
  }
  set-option buffer modelinefmt "%opt{modelinefmt_tabs} %opt{modeline_buflist}"
}

define-command tab-nav -params 1 %{
  execute-keys %sh{
    direction="$1"
    done=false

    eval "set -- $kak_quoted_buflist"
    for buf; do
      if $done; then
        break
      fi

      if [ "$buf" = "*debug*" ] && [ "$kak_bufname" != "*debug*" ]; then
        continue
      fi

      if [ "$buf" = "$kak_bufname" ]; then
        done=true
        prev="$last"
      fi
      last="$buf"
    done
    next="$buf"

    if [ "$direction" = "prev" ] && [ -n "$prev" ]; then
      echo ": buffer $prev<ret>"
    elif [ "$direction" = "next" ] && [ -n "$next" ]; then
      echo ": buffer $next<ret>"
    fi
  }
  refresh-buflist
}

define-command tab-move -params 1 %{
  execute-keys %sh{
    direction="$1"
    done=false

    eval "set -- $kak_quoted_buflist"
    for buf; do
      if $done; then
        break
      fi

      if [ "$buf" = "*debug*" ] && [ "$kak_bufname" != "*debug*" ]; then
        continue
      fi

      if [ "$buf" = "$kak_bufname" ]; then
        done=true
        prev="$last"
      fi
      last="$buf"
    done
    next="$buf"
    curr="$kak_bufname"

    # prev, curr, and next are now set properly.
    # prev/next will be empty if curr is at the front /back of the buflist
    if [ "$direction" = "prev" ] && [ -n "$prev" ]; then
      swap="$prev"
    elif [ "$direction" = "next" ] && [ -n "$next" ]; then
      swap="$next"
    else
      exit
    fi

    bufs_to_arrange=""
    for buf; do
      if [ "$buf" = "$swap" ]; then
        buf="$curr"
      elif [ "$buf" = "$curr" ]; then
        buf="$swap"
      fi
      bufs_to_arrange="$bufs_to_arrange'$buf' "
    done

    if [ -n "$bufs_to_arrange" ]; then
      echo ": arrange-buffers $bufs_to_arrange<ret>"
    fi
  }
  refresh-buflist
}

define-command delete-saved-buffers -docstring "delete all saved buffers" %{
  evaluate-commands %sh{
    deleted=0
    eval "set -- $kak_quoted_buflist"
    while [ "$1" ]; do
      echo "try %{delete-buffer '$1'}"
      echo "echo -markup '{Information}$deleted buffers deleted'"
      deleted=$((deleted+1))
      shift
    done
  }
}

define-command delete-all-saved-except-current -docstring "delete all saved buffers except current one" %{
  evaluate-commands %sh{
    deleted=0
    eval "set -- $kak_quoted_buflist"
    while [ "$1" ]; do
      if [ "$1" != "$kak_bufname" ]; then
        echo "try %{delete-buffer '$1'}"
        echo "echo -markup '{Information}$deleted buffers deleted'"
        deleted=$((deleted+1))
      fi
      shift
    done
  }

  refresh-buflist
}

define-command delete-all-except-current -docstring "delete all buffers except current one" %{
  evaluate-commands %sh{
    deleted=0
    eval "set -- $kak_quoted_buflist"
    while [ "$1" ]; do
      if [ "$1" != "$kak_bufname" ]; then
        echo "delete-buffer! '$1'"
        echo "echo -markup '{Information}$deleted buffers deleted'"
        deleted=$((deleted+1))
      fi
      shift
    done
  }

  refresh-buflist
}

hook global WinCreate .* %{
  hook window WinDisplay .* %{
    evaluate-commands refresh-buflist
  }

  hook window NormalIdle .* %{
    evaluate-commands refresh-buflist
  }
}


