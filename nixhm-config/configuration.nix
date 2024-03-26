# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{  pkgs,  ... }:
let
  user = "vj";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	    <home-manager/nixos>
    ];

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

    programs.i3status-rust.enable = true;

    home.packages = with pkgs; [
      asciiquarium
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
