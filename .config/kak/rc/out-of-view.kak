provide-module out-of-view %{
  # Public
  declare-option -docstring 'Format' str out_of_view_format '(↑%opt{out_of_view_selection_above_count}↓%opt{out_of_view_selection_below_count})'
  # Private
  declare-option -hidden -docstring 'Status line' str out_of_view_status_line
  declare-option -hidden -docstring 'Number of selections above the window' int out_of_view_selection_above_count 0
  declare-option -hidden -docstring 'Number of selections below the window' int out_of_view_selection_below_count 0

  define-command -docstring 'Enable out-of-view' out-of-view-enable %{
    hook -group out-of-view global NormalIdle .* %{
      out-of-view-update
      set-option window out_of_view_status_line ''
      evaluate-commands %sh{
        if test "$kak_opt_out_of_view_selection_above_count" -gt 0 -o "$kak_opt_out_of_view_selection_below_count" -gt 0; then
          printf 'set-option window out_of_view_status_line "%s"\n' "$kak_opt_out_of_view_format"
        fi
      }
    }
  }

  define-command -docstring 'Disable out-of-view' out-of-view-disable %{
    remove-hooks global out-of-view
    set-option window out_of_view_status_line ''
    set-option window out_of_view_selection_above_count 0
    set-option window out_of_view_selection_below_count 0
  }

  define-command -hidden out-of-view-update %{
    # Restore _t_ (top) and _b_ (bottom) registers.
    evaluate-commands -save-regs 'tb' %{
      # Window top line:
      evaluate-commands -draft %{
        execute-keys 'gt'
        set-register t %val{cursor_line}
      }
      # Window bottom line:
      evaluate-commands -draft %{
        execute-keys 'gb'
        set-register b %val{cursor_line}
      }
      # Proceed selections
      evaluate-commands %sh{
        selection_above_count=0
        selection_below_count=0
        window_top_line=$kak_reg_t
        window_bottom_line=$kak_reg_b
        eval "set -- $kak_selections_desc"
        # Selection description format: {anchor-line}.{anchor-column},{cursor-line}.{cursor-column}
        for selection do
          cursor=${selection#*,}
          cursor_line=${cursor%.*}
          cursor_column=${cursor#*.}
          if test "$cursor_line" -lt "$window_top_line"; then
            selection_above_count=$((selection_above_count + 1))
          elif test "$cursor_line" -gt "$window_bottom_line"; then
            selection_below_count=$((selection_below_count + 1))
          fi
        done
        printf 'set-option window out_of_view_selection_above_count %d\n' "$selection_above_count"
        printf 'set-option window out_of_view_selection_below_count %d\n' "$selection_below_count"
      }
    }
  }
}
