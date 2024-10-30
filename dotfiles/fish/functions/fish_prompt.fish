#!/usr/bin/env fish

function __current_path
  set pwd_result (pwd)
  if test (string length $pwd_result) -gt (math $COLUMNS - 10)
	  echo -n (set_color --bold blue) (prompt_pwd) (set_color normal) 
  else
	  echo -n (set_color --bold blue) $pwd_result (set_color normal) 
  end
end

function fish_prompt
  set -g fish_prompt_git_status_staged "o"
  set -g fish_prompt_git_status_conflicted 'x'
  set -g fish_prompt_git_status_changed '+'
  set -g fish_prompt_git_status_untracked "?"
  set -g fish_prompt_git_status_clean "✔"

  if [ $status -eq 0 ]
    set status_face (set_color brgreen --bold)"*(·_·) >> \$ "
  else
    set status_face (set_color brblue --bold)"'(;-;) >> \$ "
  end

  set git_branch (__fish_git_prompt)

  echo -n (set_color white)"╭─"(set_color normal)
  # __user_host
  __current_path
  if test -n "$git_branch"
    echo -e ''
    echo -n "│ $git_branch"(set_color normal)
  end
  echo -e ''
  echo (set_color white)"╰─"$status_face(set_color normal)
end

