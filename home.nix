{ config, pkgs, lib, ... }:
{
  # ================================
  # HOME MANAGER BASIC CONFIG
  # ================================
  home.username = "rstoffel";
  home.homeDirectory = "/Users/rstoffel";
  home.stateVersion = "23.11";

  # ================================
  # USER PACKAGES (Development tools)
  # ================================
  home.packages = with pkgs; [
    # Enhanced CLI tools
    neovim
    eza              # Better ls
    bat              # Better cat
    zoxide           # Smart cd
    fastfetch        # System info
    lazygit          # Git TUI
    tmux             # Terminal multiplexer
    btop             # System monitor

    # Development tools
    eslint           # JavaScript linting

    # Shell enhancements
    blesh                   # Bash Line Editor
    nix-bash-completions    # Better completions
    zsh-powerlevel10k       # Zsh theme
    zsh-autosuggestions     # Zsh autosuggestions
    zsh-syntax-highlighting # Zsh syntax highlighting
    zsh-completions         # Additional completions
  ];

  # ================================
  # SHELL CONFIGURATION
  # ================================
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "web-search"
        "copypath"
        "copyfile"
        "copybuffer"
        "dirhistory"
        "history"
        "jsontools"
        "colored-man-pages"
        "command-not-found"
        "extract"
        "brew"
        "macos"
        "vscode"
        "node"
        "npm"
      ];
      theme = ""; # We'll use Powerlevel10k instead
    };

    # ================================
    # ZSH ENVIRONMENT VARIABLES
    # ================================
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
      SUDO_EDITOR = "nvim";
      BROWSER = "zen";
      TERMINAL = "ghostty";
      
      # Development environment
      NODE_OPTIONS = "--max-old-space-size=8192";
      
      # Salesforce development
      SFDX_CONTAINER_MODE = "true";
      SF_CONTAINER_MODE = "true";
      SFDX_DISABLE_TELEMETRY = "true";
      
      # Python development
      PYTHONDONTWRITEBYTECODE = "1";
      PYTHONUNBUFFERED = "1";
      
      # Enhanced tools
      BAT_THEME = "Catppuccin-mocha";
      MANPAGER = "nvim +Man!";
      LESS = "-R";
      
      # XDG Base Directory
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
    };

    # ================================
    # ZSH HISTORY CONFIGURATION
    # ================================
    history = {
      size = 50000;
      save = 50000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      share = true;
    };

    # ================================
    # ZSH ALIASES
    # ================================
    shellAliases = {
      # System navigation
      c = "clear";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      "~" = "cd ~";
      "-" = "cd -";
      
      # Enhanced ls with eza
      ls = "eza -lh --group-directories-first --icons=auto";
      lsa = "ls -a";
      lt = "eza --tree --level=2 --long --icons --git";
      lta = "lt -a";
      
      # File operations
      rm = "rm -i";
      mv = "mv -i";
      cp = "cp -i";
      mkdir = "mkdir -p";
      
      # Git aliases (matching Artemis)
      g = "git";
      gs = "git status";
      gss = "git status -s";
      ga = "git add";
      gaa = "git add --all";
      gc = "git commit -m";
      gcam = "git commit -a -m";
      gp = "git push";
      gpl = "git pull";
      gb = "git branch";
      gco = "git checkout";
      gd = "git diff";
      gl = "git log --oneline --graph --decorate";
      gundo = "git reset --soft HEAD~1";
      gpush = "git push -u origin $(git branch --show-current)";
      
      # Development shortcuts
      dev = "cd ~/dev";
      downloads = "cd ~/Downloads";
      
      # Nix Darwin management
      rebuild = "sudo darwin-rebuild switch --flake ~/nix-darwin-config";
      nix-update = "nix flake update ~/nix-darwin-config";
      nix-clean = "nix-collect-garbage -d";
      
      # Network and system
      ports = "netstat -tuln";
      myip = "curl -s ifconfig.me";
      ping = "ping -c 5";
      
      # macOS specific
      flushdns = "sudo dscacheutil -flushcache";
      showfiles = "defaults write com.apple.finder AppleShowAllFiles YES && killall Finder";
      hidefiles = "defaults write com.apple.finder AppleShowAllFiles NO && killall Finder";
      
      # Development tools
      serve = "python3 -m http.server 8000";
      json = "python3 -m json.tool";
    };

    # ================================
    # ZSH INITIALIZATION
    # ================================
    initContent = ''
      # Enable Powerlevel10k instant prompt
      if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
        source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
      fi

      # Load Powerlevel10k theme
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme

      # Initialize Zoxide (smart cd replacement)
      if command -v zoxide >/dev/null 2>&1; then
          eval "$(zoxide init zsh)"
      fi

      # FZF configuration with Catppuccin Mocha theme
      export FZF_DEFAULT_OPTS="
      --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
      --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
      --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
      --height 40% --layout=reverse --border --margin=1 --padding=1"

      # Use fd for file search if available
      if command -v fd >/dev/null 2>&1; then
          export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
          export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
          export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
      fi

      # Custom functions
      mkcd() {
          mkdir -p "$1" && cd "$1"
      }

      backup() {
          cp "$1" "$1.backup.$(date +%Y%m%d_%H%M%S)"
      }

      # macOS optimized open function
      open() {
          if [[ "$#" -eq 0 ]]; then
              command open .
          else
              command open "$@"
          fi
      }

      # Smart cd function (using zoxide)
      cd() {
          if [ $# -eq 0 ]; then
              builtin cd ~ && return
          elif [ -d "$1" ]; then
              builtin cd "$1"
          else
              z "$@"
          fi
      }

      # Load Powerlevel10k configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
      
      # Salesforce CLI completion
      if command -v sf >/dev/null 2>&1; then
          eval "$(sf autocomplete:script zsh)"
      fi

      # Node.js version management with mise
      if command -v mise >/dev/null 2>&1; then
          eval "$(mise activate zsh)"
      fi
    '';
  };

  # ================================
  # ZOXIDE CONFIGURATION
  # ================================
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    enableFishIntegration = true;
  };

  # ================================
  # GIT CONFIGURATION
  # ================================
  programs.git = {
    enable = true;
    userName = "RyanStoffel";
    userEmail = "772612@calbaptist.edu";
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      core.editor = "nvim";
      merge.tool = "nvim";
      diff.tool = "nvim";
    };
  };

  # ================================
  # DOTFILES AND CONFIGURATION FILES
  # ================================
  home.file = {
    # Global gitignore
    ".gitignore_global".text = ''
      # macOS
      .DS_Store
      .AppleDouble
      .LSOverride
      ._*
      .DocumentRevisions-V100
      .fseventsd
      .Spotlight-V100
      .TemporaryItems
      .Trashes
      .VolumeIcon.icns
      .com.apple.timemachine.donotpresent
      .AppleDB
      .AppleDesktop
      Network Trash Folder
      Temporary Items
      .apdisk
      
      # Development
      node_modules/
      .env
      .env.local
      *.log
      npm-debug.log*
      yarn-debug.log*
      yarn-error.log*
      
      # IDE
      .vscode/
      .idea/
      *.swp
      *.swo
      *~
      
      # Salesforce
      .sfdx/
      .sf/
      .vscode/settings.json
      **/lwc/**/coverage/
      **/aura/**/coverage/
    '';
  };

  # ================================
  # ENABLE HOME MANAGER
  # ================================
  programs.home-manager.enable = true;
}