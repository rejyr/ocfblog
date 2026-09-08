+++
date = '2026-09-08T12:36:27-07:00'
draft = false
title = 'desktop customization'
+++

# problem

the [OCF](ocf.io) has a [computer lab](https://bestdocs.ocf.io/user-docs/services/lab/) that runs [NixOS](https://nixos.org/) (wow very cool).

I want to get my [dotfiles](https://github.com/Rejyr/dotfiles) (at least [neovim](https://neovim.io/) and [fish](https://fishshell.com/)) working on the desktop.

# huh

what do the [docs](https://bestdocs.ocf.io/user-docs/) say?

there's a page on [desktop customization](https://bestdocs.ocf.io/user-docs/services/lab/desktop-customization/). it says that the default desktop environment is [KDE Plasma](https://kde.org/plasma-desktop/). it's currently [Cosmic](https://system76.com/cosmic). I'll send in a PR.

it recommends a [home manager (hm)](https://github.com/nix-community/home-manager) [flake](https://nix.dev/concepts/flakes.html). in my dotfiles, I moved away from hm to [hjem](https://github.com/feel-co/hjem). hm felt like it was always doing too much, and it was a pain when the hm config in nix did not match the updated original config.

anyhoo, I went through the docs, followed what it said, and relogged into a black monitor.

## monitor misshap
confession: I did not even test the flake. it's even in the docs:
> Then, re-apply the flake with `nix run home-manager -- switch --flake ~/remote/home-manager`.

both the monitor and desktop were on (indicator lights), but no output. I had to switch [TTYs](https://askubuntu.com/questions/66195/what-is-a-tty-and-how-do-i-access-a-tty), and `michaelzls` nuked my `.desktoprc` for my desktop to work again.

# solution

I managed to adapt `laksith19's` [desktoprc](https://github.com/laksith19/ocf-desktoprc/) for my own (with no actual dotfiles yet).

here is my `home.nix`:
```nix
{ config, pkgs, ... }:

{
  home.username = "jerrywang";
  home.homeDirectory = "/home/j/je/jerrywang";

  home.stateVersion = "26.05";

  home.packages = with pkgs; [
    zola
  ];

  home.file = {
  };

  home.sessionVariables = {
  };

  xdg.configFile."fish/config.fish".force = true;
  xdg.configFile."gh/config.yml".force = true;

  programs = {
    bash = {
      enable = true;
      initExtra = ''
        # "check if parent process is not fish" && "make nested shells work properly"
        if grep -qv fish /proc/$PPID/comm && [[ $SHLVL == [12] ]]; then
            # set $SHELL for better integration with programs like nix shell, tmux, etc.
            SHELL=${pkgs.fish}/bin/fish exec fish
        fi
      '';
    };
    fish = {
      enable = true;
      shellAbbrs = {
        n = "nvim";
      };
    };
    zoxide = {
      enable = true;
      enableFishIntegration = true;
    };

    git = {
      enable = true;
      settings = {
        user.name = "Jerry Wang";
        user.email = "myrealemail@example.com";
      };
    };

    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
```

this was a pain just to update my shell. I'll use [nix dev environments](https://nixos-and-flakes.thiscute.world/development/dev-environments) with [wrappers](https://github.com/nix-community/nix-wrapper-modules) from my dotfiles next time.

[my desktoprc](https://github.com/rejyr/ocf-desktoprc).

shoutout `michaelzls` diagnosing my skill issues.

fin!
