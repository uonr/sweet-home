set nix_daemon_script /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
if test -f $nix_daemon_script
    source $nix_daemon_script
end