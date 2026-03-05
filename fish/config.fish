if status is-interactive
fastfetch
end

if test "$TERM" != "linux" 
    starship init fish | source
end

set -g fish_greeting
