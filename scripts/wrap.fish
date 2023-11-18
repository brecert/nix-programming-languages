# sourcehut:~fgaz/nix-bubblewrap

set options \
    --dev /dev \
    --tmpfs /tmp \
    --tmpfs $HOME \
    --dir $HOME/run \
    --chdir $HOME/run

nix-bwrap -bwrap-options "$options" -- $argv