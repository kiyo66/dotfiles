#!/usr/bin/env fish

if status is-interactive

    alias pys='python3 /home/ogawa/workspace/src/SwinTransformer-T/quant/main.py -c /home/ogawa/workspace/src/SwinTransformer-T/config.toml'
    alias py='python3'
    alias cds='cd /home/ogawa/workspace/src/SwinTransformer-T'
    alias c='clear'
    alias vim="nvim"
    alias t='tmux'
    alias tn='tmux new -s'
    alias ta='tmux a -t'
    alias tk='tmux kill-server'

end

# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'yes'
set __fish_git_prompt_showuntrackedfiles 'yes'
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_color_upstream_ahead green
set __fish_git_prompt_color_upstream_behind red

# Status Chars
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_untrackedfiles '☡'
set __fish_git_prompt_char_stashstate '↩'
set __fish_git_prompt_char_upstream_ahead '+'
set __fish_git_prompt_char_upstream_behind '-'

fish_add_path ~/nvim-linux-x86_64/bin/

