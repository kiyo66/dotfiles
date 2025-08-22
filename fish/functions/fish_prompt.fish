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
    set -g fish_prompt_git_status_staged     "o"
    set -g fish_prompt_git_status_conflicted "x"
    set -g fish_prompt_git_status_changed    "+"
    set -g fish_prompt_git_status_untracked  "?"
    set -g fish_prompt_git_status_clean      "✔"

    if test $status -eq 0
        set status_face (set_color brgreen --bold)"*(·_·) >> \$ "
    else
        set status_face (set_color brblue --bold)"'(;-;) >> \$ "
    end

    set -l branch (command git rev-parse --abbrev-ref HEAD 2>/dev/null)

    echo (set_color white)"╭─"(set_color blue --bold)(whoami)'@'(hostname)
    echo (set_color white)"│ "(set_color blue --bold)(pwd)

    if test -n "$branch"
        set -l raw_prompt (__fish_git_prompt)
        set -l git_state (string match -r --groups-only '\|([^)]+)\)' -- $raw_prompt)

        echo -n (set_color white)"│ "
        echo -n (set_color white)"("
        echo -n (set_color yellow --bold)"$branch"
        if test -n "$git_state"
            echo -n (set_color white)"|"
            echo -n $git_state
        end
        echo (set_color white)")"
    end

    echo -n (set_color white)"╰─"
    echo -n $status_face
    set_color normal
end

