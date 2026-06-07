#!/usr/bin/env fish

function __current_path
  set -l pwd_result (pwd)

  if test (string length $pwd_result) -gt (math $COLUMNS - 10)
    printf "%s%s%s" (set_color --bold blue) (prompt_pwd) (set_color normal)
  else
    printf "%s%s%s" (set_color --bold blue) $pwd_result (set_color normal)
  end
end

function __user_host
  printf "%s|  %s%s%s" \
    (set_color white) \
    (set_color --bold cyan) \
    (hostname) \
    (set_color normal)
end

function fish_prompt
  set -l last_status $status
  set -l status_face

  set -g fish_prompt_git_status_staged "o"
  set -g fish_prompt_git_status_conflicted "x"
  set -g fish_prompt_git_status_changed "+"
  set -g fish_prompt_git_status_untracked "?"
  set -g fish_prompt_git_status_clean "✔"

  if test $last_status -eq 0
    set status_face (set_color brgreen --bold)"*(·_·) >> \$ "
  else
    set status_face (set_color brblue --bold)"'(;-;) >> \$ "
  end

  printf "%s╭─ %s" (set_color white) (set_color normal)
  __current_path
  __fish_git_prompt
  printf "\n"

  __user_host
  printf "\n"

  printf "%s╰─%s%s%s" \
    (set_color white) \
    (set_color normal) \
    "$status_face" \
    (set_color normal)
end
