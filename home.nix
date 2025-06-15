{ config, pkgs, lib, ... }:
{
  home.username = "rstoffel";
  home.homeDirectory = "/Users/rstoffel";
	programs.zoxide = {
  	enable = true;
  	enableZshIntegration = false;
	};

	programs.starship = {
		enable = true;
		settings = {
			# Get editor completions based on the config schema
			"$schema" = 'https://starship.rs/config-schema.json'

			# Inserts a blank line between shell prompts
			add_newline = true

			# Replace the '❯' symbol in the prompt with '➜'
			[character] # The name of the module we are configuring is 'character'
			success_symbol = '[➜](bold green)' # The 'success_symbol' segment is being set to '➜' with the color 'bold green'

			# Disable the package module, hiding it from the prompt completely
			[package]
			disabled = true
		};
	};

  programs.zsh = {
    enable = true;
    shellAliases = {
			# General Aliases
      ll = "ls -la";
			c = "clear";
			cat = "bat";

			# Basic git shortcuts
    	gs = "git status";
    	ga = "git add";
    	gaa = "git add --all";
    	gc = "git commit -m";
    	gco = "git checkout";
    	gb = "git branch";
    	gd = "git diff";
    	gl = "git log --oneline --graph --decorate";

    	# Push/Pull shortcuts
    	gp = "git push";
    	gpl = "git pull";
    	gpum = "git push -u origin main";
    	gpom = "git push origin main";
    	gplom = "git pull origin main";

    	# Branch management
    	gcb = "git checkout -b";
    	gcom = "git checkout main";
    	gbr = "git branch -r";
    	gbd = "git branch -d";

    	# Stash shortcuts
    	gst = "git stash";
    	gstp = "git stash pop";
    	gstl = "git stash list";

    	# Reset shortcuts
    	grh = "git reset --hard";
    	grs = "git reset --soft";
    	gru = "git reset HEAD~1";

    	# Remote shortcuts
    	gf = "git fetch";
    	gfa = "git fetch --all";
    	gr = "git remote -v";

    	# Quick commit and push
    	gac = "git add --all && git commit -m";

			# Nix Aliases
			rebuild = "sudo darwin-rebuild switch --flake ~/nix-darwin-config";
    };
    initContent = ''
			eval "$(starship init zsh)"
    	eval "$(zoxide init --cmd cd zsh)"
    '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "zsh-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-syntax-highlighting";
          rev = "0.8.0";
          sha256 = "sha256-iJdWopZwHpSyYl5/FQXEW7gl/SrKaYDEtTH9cGP7iPo=";
        };
      }
    ];
  };
  fonts.fontconfig.enable = true;
  home.stateVersion = "23.11";
}
