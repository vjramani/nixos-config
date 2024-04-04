# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{  pkgs, lib, ... }:
let
  user = "vj";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	    <home-manager/nixos>
    ];

    nix.settings.experimental-features = ["nix-command" "flakes"];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IN";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
    LC_CTYPE = "en_US.utf8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
	  enable = true;
	  displayManager = {
		  lightdm.enable = true;
		  autoLogin.enable = true;
		  autoLogin.user = "${user}";
		  setupCommands = ''
			  ${pkgs.xorg.xrandr}/bin/xrandr -s 1920x1080
		  '';
	  };
    windowManager.i3 = {
      enable = true;
      configFile = ./i3-config;
    };
    
    layout = "us";
    xkbVariant = "";
  };
  services.picom.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
    initialPassword = "o";
  };

  home-manager.users.${user} = {pkgs, ...}: {
    programs.home-manager.enable = true;

    programs.bash.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    # i3 settings
    xsession = {
      enable = true;
      windowManager.i3 = let
        modkey = "Mod4";
      in{
        enable = true;
        config = {
          bars = [];
          modifier = "${modkey}";
          defaultWorkspace = "workspace number 1";
          keybindings = lib.mkOptionDefault{
              "${modkey}+Return" = "exec --no-startup-id alacritty";
              "Ctrl+Shift+q" = "kill";
              "${modkey}+d" = "exec --no-startup-id rofi -show combi -show-icons";

              "${modkey}+h" = "focus left";
              "${modkey}+j" = "focus down";
              "${modkey}+k" = "focus up";
              "${modkey}+l" = "focus right";
              
              "${modkey}+Shift+h" = "move left";
              "${modkey}+Shift+j" = "move down";
              "${modkey}+Shift+k" = "move up";
              "${modkey}+Shift+l" = "move right";

              "${modkey}+Ctrl+h" = "split h";
              "${modkey}+Ctrl+v" = "split v";

              "${modkey}+f" = "fullscreen toggle";

              "${modkey}+Shift+c" = "reload";
              "${modkey}+Shift+r" = "restart";

              "${modkey}+1" = "workspace number 1";
              "${modkey}+2" = "workspace number 2";
              "${modkey}+3" = "workspace number 3";
              "${modkey}+4" = "workspace number 4";
              "${modkey}+5" = "workspace number 5";
              "${modkey}+6" = "workspace number 6";
              "${modkey}+7" = "workspace number 7";
              "${modkey}+8" = "workspace number 8";
              "${modkey}+9" = "workspace number 9";
              "${modkey}+0" = "workspace number 10";

              "${modkey}+Shift+1" = "move container to workspace number 1";
              "${modkey}+Shift+2" = "move container to workspace number 2";
              "${modkey}+Shift+3" = "move container to workspace number 3";
              "${modkey}+Shift+4" = "move container to workspace number 4";
              "${modkey}+Shift+5" = "move container to workspace number 5";
              "${modkey}+Shift+6" = "move container to workspace number 6";
              "${modkey}+Shift+7" = "move container to workspace number 7";
              "${modkey}+Shift+8" = "move container to workspace number 8";
              "${modkey}+Shift+9" = "move container to workspace number 9";
              "${modkey}+Shift+0" = "move container to workspace number 10";

              "${modkey}+p" = "workspace prev";
              "${modkey}+n" = "workspace next";

              "${modkey}+r" = "mode resize";

              "${modkey}+Ctrl+Return" = "exec --no-startup-id rofi -show p -modi p:rofi-power-menu";
            };
          modes.resize = {
            h = "resize shrink width 8px or 8 ppt";
            j = "resize shrink height 8px or 8 ppt";
            k = "resize grow height 8px or 8 ppt";
            l = "resize grow width 8px or 8 ppt";
            Return = "mode default";
            Escape = "mode default";
          };
          gaps = {
            inner = 2;
          };
          window = {
            border = 0;
            titlebar = false;
            hideEdgeBorders = "both";
          };
          workspaceAutoBackAndForth = true;
          startup = [
            #{ command = "xss-lock --transfer-sleep-lock -- i3lock --nofork -k --indicator --inside-color=3C3836FF --ring-color=665C54FF --insidever-color=458588FF --ringver-color=689D6AFF --insidewrong-color=CC241DFF --ringwrong-color=665C54FF -i /home/${user}/wallpapers/lock.png";always = true; notification = false;}
            #{ command = "xss-lock --transfer-sleep-lock -- betterlockscreen -u '/home/${user}/wallpapers/lock.png'"; always = true; notification = false;}
            #{ command = "xss-lock --transfer-sleep-lock -- i3lock --nofork -i /home/${user}/wallpapers/lock.png"; always = true; notification = false;}
            { command = "feh --bg-fill --randomize /home/${user}/wallpapers/*"; always = true; notification = false; }
          ];
        };
      };
    };
    
    # temporary settings to make vim more usable
    programs.vim = {
	enable = true;
	defaultEditor = true;
	extraConfig = ''
		set number
		set relativenumber
        '';
        plugins = [
          pkgs.vimPlugins.comment-nvim
          pkgs.vimPlugins.vim-nix
        ];
    };

    # alacritty settings
    programs.alacritty = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./alacritty.toml);
    };

    # rofi settings
    programs.rofi = {
        enable = true;
        theme = "gruvbox-dark";
        plugins = [ pkgs.rofi-calc ];
    };

    # starship settings
    programs.starship = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };

    # polybar settings
    services.polybar = {
        enable = true;
        script = ''
          killall -q polybar
          polybar status &
          '';
        config = ./polybar;
    };

    home.packages = with pkgs; [
      asciiquarium
      i3lock-color
      lunarvim
      rofi-power-menu
      xss-lock
    ];

    home.stateVersion = "23.11";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    alacritty
    bat
    fastfetch
    feh
    font-manager
    git
    htop
    killall
    remarshal
    vim
    wget
  ];

  fonts.packages = with pkgs; [
	  (nerdfonts.override { fonts = ["FiraCode" "SpaceMono" "RobotoMono" "Noto"]; })
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  system.stateVersion = "23.11"; # Did you read the comment?

}
