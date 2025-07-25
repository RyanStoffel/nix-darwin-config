{
  description = "Ryan's nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, config, ... }: {
			nixpkgs.config.allowUnfree = true;
			nixpkgs.config.allowUnsupportedSystem = true;
      environment.systemPackages = with pkgs; [
				# Programming
        vim
        neovim
        git
        gh
        jdk21
        python313
        python313Packages.pip
        nodejs_22
        wget
        curl
        htop
				eslint
				vscode
				zoxide
				fzf
				bat
				starship
				tree
				gitkraken
        ripgrep
        stow
        postman
        tmux

				# Entertainment
				discord
				spotify
        fastfetch

				# Productivity
				slack
				obsidian
        notion-app
      ];

      system.primaryUser = "rstoffel";

      users.users.rstoffel = {
        name = "rstoffel";
        home = "/Users/rstoffel";
      };

      security.pam.services.sudo_local.touchIdAuth = true;

      nix.settings.experimental-features = "nix-command flakes";

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
      };

      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";

      homebrew = {
        enable = true;
        onActivation = {
          autoUpdate = false;
          cleanup = "uninstall";
        };

        brews = [
					"sf"
          "stylua"
          "clang-format"
          "google-java-format"
          "prettier"
          "shfmt"
          "black"
        ];

        casks = [
					"raycast"
					"vlc"
          "font-jetbrains-mono-nerd-font"
          "ghostty"
          "kitty"
          "zen"
          "zed"
        ];
      };

      system.defaults = {
        dock = {
          autohide = true;
          autohide-delay = 0.0;
          autohide-time-modifier = 0.0;
          show-recents = false;
          launchanim = false;
          orientation = "bottom";
          tilesize = 48;
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
        };

        screencapture = {
          location = "~/Pictures/Screenshots/";
          type = "png";
          disable-shadow = true;
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
        };

        loginwindow = {
          GuestEnabled = false;
					SHOWFULLNAME = false;
					LoginwindowText = "Welcome to Ryan's MacBook Pro";
        };

        trackpad = {
          Clicking = true;
          TrackpadThreeFingerDrag = true;
        };
      };
    };
  in {
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
  };
}


