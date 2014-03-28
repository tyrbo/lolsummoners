#!/bin/sh
BASE="$HOME/Projects/lolsummoners"
cd $BASE

tmux start-server
tmux new-session -d -s lolsummoners -n zsh
tmux new-window -t lolsummoners:1 -n vim
tmux new-window -t lolsummoners:2 -n server
tmux new-window -t lolsummoners:3 -n redis

tmux send-keys -t lolsummoners:vim "cd $BASE; vim" C-m
tmux send-keys -t lolsummoners:server "cd $BASE; bin/rails s" C-m
tmux send-keys -t lolsummoners:redis "redis-server" C-m\

tmux select-window -t lolsummoners:vim
tmux attach-session -d -t lolsummoners
