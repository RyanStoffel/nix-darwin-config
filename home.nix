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
      "$schema" = "https://starship.rs/config-schema.json";
      add_newline = true;
    
      package.disabled = true;
    };
  };

  programs.zsh = {
    enable = true;
    
    initContent = ''
      source "$HOME/.dotfiles/zsh/config.zsh";
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
