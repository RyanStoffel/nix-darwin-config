{
  description = "Ryan's nix-darwin system flake - system level configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, nvf }:
  let
    configuration = { pkgs, config, ... }: {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnsupportedSystem = true;
      
      # ================================
      # SYSTEM PACKAGES (Core utilities only)
      # ================================
      environment.systemPackages = with pkgs; [
        # Core system tools
        vim
        wget
        curl
        git
        gh
        htop
        tree
        stow
        sketchybar

        # Development runtimes (system-wide)
        jdk21
        python313
        python313Packages.pip
        nodejs_22

        # Essential CLI tools
        ripgrep
        fd
        fzf
        
        # Mac App Store CLI
        mas
      ];

      # ================================
      # SYSTEM CONFIGURATION
      # ================================
      system.primaryUser = "rstoffel";

      users.users.rstoffel = {
        name = "rstoffel";
        home = "/Users/rstoffel";
      };

      # Enhanced Touch ID support
      security.pam.services = {
        sudo_local.touchIdAuth = true;
      };

      # ================================
      # NIX CONFIGURATION
      # ================================
      nix.settings.experimental-features = "nix-command flakes";

      # ================================
      # SYSTEM SHELL CONFIGURATION
      # ================================
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
        enableFzfCompletion = true;
        enableFzfGit = true;
        enableFzfHistory = true;
        enableSyntaxHighlighting = true;
      };

      programs.fish.enable = true;

      # ================================
      # SYSTEM INFO
      # ================================
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

      # ================================
      # HOMEBREW (System-wide applications)
      # ================================
      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = false;
          cleanup = "uninstall";
          upgrade = true;
        };

        # System-level tools and formatters
        brews = [
          "sf"                    # Salesforce CLI
          "stylua"               # Lua formatter
          "clang-format"         # C/C++ formatter
          "google-java-format"   # Java formatter
          "prettier"             # Web formatter
          "shfmt"                # Shell formatter
          "black"                # Python formatter
          "mise"                 # Development environment manager
        ];

        # GUI Applications
        casks = [
          # Development
          "zed"
          "vscodium"
          "gitkraken"
          "postman"
          
          # Terminals
          "ghostty"
          "kitty"
          "wezterm"
          "alacritty"
          
          # Browsers
          "zen"
          "chromium"
          
          # Productivity
          "raycast"
          "rectangle"
          "alt-tab"
          "stats"
          "itsycal"
          
          # Media
          "vlc"
          "spotify"
          "discord"
          "slack"
          
          # Utilities
          "1password"
          "obsidian"
          "notion"
          
          # Fonts
          "font-jetbrains-mono-nerd-font"
        ];
      };

      # ================================
      # SYSTEM DEFAULTS (macOS settings)
      # ================================
      system.defaults = {
        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.0;
          show-recents = false;
          launchanim = false;
          orientation = "bottom";
          tilesize = 48;
          minimize-to-application = true;
          show-process-indicators = true;
        };

        finder = {
          AppleShowAllExtensions = true;
          FXPreferredViewStyle = "clmv";
          ShowPathbar = true;
          FXEnableExtensionChangeWarning = false;
          _FXShowPosixPathInTitle = true;
          FXDefaultSearchScope = "SCcf";
          CreateDesktop = true;
          NewWindowTarget = "Other";
          NewWindowTargetPath = "file://\${HOME}/Documents/";
          ShowStatusBar = true;
          QuitMenuItem = true;
        };

        screencapture = {
          location = "~/Pictures/Screenshots/";
          type = "png";
          disable-shadow = true;
          show-thumbnail = false;
        };

        NSGlobalDomain = {
          AppleKeyboardUIMode = 3;
          ApplePressAndHoldEnabled = false;
          InitialKeyRepeat = 15;
          KeyRepeat = 2;
          NSAutomaticCapitalizationEnabled = false;
          NSAutomaticDashSubstitutionEnabled = false;
          NSAutomaticPeriodSubstitutionEnabled = false;
          NSAutomaticQuoteSubstitutionEnabled = false;
          NSAutomaticSpellingCorrectionEnabled = false;
          NSNavPanelExpandedStateForSaveMode = true;
          NSNavPanelExpandedStateForSaveMode2 = true;
          NSDocumentSaveNewDocumentsToCloud = false;
          PMPrintingExpandedStateForPrint = true;
          PMPrintingExpandedStateForPrint2 = true;
        };

        loginwindow = {
          GuestEnabled = false;
          SHOWFULLNAME = false;
          LoginwindowText = "Welcome to Ryan's MacBook Pro";
        };

        trackpad = {
          Clicking = true;
          TrackpadThreeFingerDrag = true;
          TrackpadRightClick = true;
        };

        menuExtraClock = {
          ShowSeconds = true;
          ShowDate = 1;
        };

        ActivityMonitor = {
          OpenMainWindow = true;
          IconType = 2;
          SortColumn = "CPUUsage";
          SortDirection = 0;
        };
      };

      # ================================
      # SYSTEM ENVIRONMENT VARIABLES
      # ================================
      environment.variables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
        # Development paths
        JAVA_HOME = "${pkgs.jdk21}/lib/openjdk";
      };

      # ================================
      # SYSTEM SERVICES
      # ================================
      launchd.user.agents = {
        # Auto-update Homebrew daily
        "homebrew-update" = {
          serviceConfig = {
            ProgramArguments = [ "${pkgs.bash}/bin/bash" "-c" "brew update && brew upgrade" ];
            StartCalendarInterval = [ { Hour = 9; Minute = 0; } ];
            StandardOutPath = "/tmp/homebrew-update.log";
            StandardErrorPath = "/tmp/homebrew-update.log";
          };
        };
      };
    };

  in {
    # ================================
    # DARWIN SYSTEM CONFIGURATION
    # ================================
    darwinConfigurations."Apollo" = nix-darwin.lib.darwinSystem {
      modules = [
        configuration
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.rstoffel = import ./home.nix;
        }
      ];
    };

    # ================================
    # NVF NEOVIM CONFIGURATION
    # ================================
    packages."aarch64-darwin".default = 
      (nvf.lib.neovimConfiguration {
        pkgs = nixpkgs.legacyPackages."aarch64-darwin";
        modules = [
          {
            vim = {
              options = {
                tabstop = 2;
                shiftwidth = 2;
                autoindent = true;
                wrap = false;
              };

              autopairs = {
                nvim-autopairs.enable = true;
              };

              theme = {
                enable = true;
                name = "catppuccin";
                style = "mocha";
                transparent = true;
              };

              statusline.lualine.enable = true;
              telescope.enable = true;
              autocomplete.nvim-cmp.enable = true;

              clipboard = {
                enable = true;
                registers = "unnamedplus";
                providers = {
                  pbcopy.enable = true;
                };
              };

              filetree.neo-tree.enable = true;

              lsp = {
                enable = true;
                formatOnSave = true;
                lspSignature.enable = true;
                lightbulb.enable = true;
              };

              languages = {
                enableFormat = true;
                enableTreesitter = true;
                bash.enable = true;
                clang.enable = true;
                tailwind.enable = true;
                java.enable = true;
                html.enable = true;
                css.enable = true;
                sql.enable = true;
                nix.enable = true;
                ts.enable = true;
              };

              keymaps = [
                {
                  key = "<leader>ee";
                  action = ":Neotree toggle<CR>";
                  mode = "n";
                  desc = "Toggle Neo-Tree";
                }
              ];
            };
          }
        ];
      }).neovim;
  };
}