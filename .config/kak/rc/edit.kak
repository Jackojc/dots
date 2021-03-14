provide-module edit %{
  define-command find-edit -params 1 -shell-script-candidates 'fd --type file' -docstring 'Edit file' %{
    edit %arg{1}
  }

  alias global f find-edit

  define-command find-edit-all -params 1 -shell-script-candidates 'fd --hidden --no-ignore --type file' -docstring 'Edit file' %{
    edit %arg{1}
  }

  alias global fa find-edit-all

  define-command scratch -docstring 'Create a scratch buffer' %{
    edit -scratch '*scratch*'
  }

  alias global s scratch

  define-command scratch-reload -docstring 'Reload the scratch buffer' %{
    edit! -scratch '*scratch*'
  }

  alias global s! scratch-reload

  define-command read-only -docstring 'Make the buffer read-only' %{
    edit -readonly %val{bufname}
  }

  alias global ro read-only
}
