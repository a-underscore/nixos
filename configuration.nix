# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
	[ # Include the results of the hardware scan.
		./hardware-configuration.nix
	];

  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  environment.systemPackages = with pkgs; [
  	prismlauncher
	ollama
  	blender
  	caffeine-ng
	wget
  	zed-editor
	python3
	seahorse
  	lua
	gocryptfs
 	fastfetch
	neovim
	alacritty
	unzip
	zip
	git
	acpi
	rustup
	nodejs
  	wireguard-tools
	networkmanager-openvpn
	protonvpn-gui
	openrgb-with-all-plugins
  ];
  
  programs.flashrom.enable = true;
  
  security.polkit.enable = true;
  networking.firewall.checkReversePath = false;

  services.hardware.openrgb.enable = true;

  programs.nix-ld.enable = true;

  services.udev.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    # Optional: Configure display settings, if necessary
    # displayManager = {
    #   ...
    # };
    # desktopManager = {
    #   ...
    # };
  };

  boot.kernelModules = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Additional configurations if required
  # For example, to manage power settings for Nouveau:
  # environment.etc."modprobe.d/nouveau.conf".text = ''
  #   options nouveau modeset=1
  # '';
  /*
  # Enable hardware acceleration for Nouveau
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      # Add packages needed for Nouveau acceleration here
      # For example, Mesa for OpenGL:
      mesa
    ];
  };*/

  nix.settings.experimental-features = [
  	"nix-command"
  	"flakes"
  ];

  services.flatpak.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-cosmic
    ];
    config.common = {
      default = [ "cosmic" "kde" ];
    };
    xdgOpenUsePortal = true;
  };
  xdg.mime.defaultApplications = {
    "application/pdf" = "org.gnome.Evince.desktop";
    "text/html" = "firefox.desktop";
    "image/*" = "imv.desktop";
  };

  users.users."a_" = {
    packages = with pkgs; [
      flatpak
    ];
  };


  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
      settings = {
        default-cache-ttl = 2592000;
        max-cache-ttl = 2592000;
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  programs.zsh.enable = true;

  users.extraUsers.a_ = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  users.users.a_.extraGroups = [ "adbusers" "networkmanager" ];

  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/disk/by-id/ata-ST2000DM008-2FR102_ZFL6752S-part1";

  boot.loader.systemd-boot.enable = true;

  networking.hostId = "c7a5e39a";

  # networking.hostName = "nixos"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  #services.xserver.enable = true;


  # Enable the GNOME Desktop Environment.
  #services.displayManager.gdm.enable = true;
  #services.desktopManager.gnome.enable = true;
  /*
  services.xserver = {
    enable = true;

    desktopManager = {
      xterm.enable = false;
    };
   
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        rofi
        dunst
        alacritty
        i3status 
	feh
     ];
    };
  };

  services.displayManager.defaultSession = "none+cosmic";
  */

  services.displayManager.cosmic-greeter.enable = true;

  services.desktopManager.cosmic.enable = true;

  # programs.i3lock.enable = true; #default i3 screen locker

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
  	enable = true;
  	pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.alice = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  programs.firefox.enable = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  services.zfs.autoSnapshot.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  
  system.stateVersion = "25.11"; # Did you read the comment?

  # boot.zfs.extraPools = [ "zpool" ];
}

