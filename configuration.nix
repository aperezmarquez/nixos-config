{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-inst"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  
  security.pki.certificateFiles = [
    "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt"
  ];

  # Set your time zone.
  time.timeZone = "Europe/Madrid";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_ES.UTF-8";
  console.keyMap = "es";
  
  hardware.graphics = {
    enable = true;
  };

  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  programs.niri.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Configure keymap in X11
  services.xserver.xkb.layout = "es";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.antonio = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      tree
    ];
    shell = pkgs.zsh;
  };

  # STOPPED USING FIREFOX, NOW SELLING AND DISTRIBUTING YOUR DATA + NEARLY UNIQUE FINGERPRINT
  # programs.firefox.enable = true;

  # Desktop fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    font-awesome
    meslo-lgs-nf
  ];
  
  # All the system Pkgs
  environment.systemPackages = with pkgs; [
    cacert
    vulkan-loader
    vim
    wget
    neovim
    git
    gh
    kitty
    waybar
    eww
    glibc
    wayland
    wayland-protocols
    libinput
    libdrm
    libxkbcommon
    libxcursor
    libvirt
    libgcc
    pixman
    meson
    ninja
    libdisplay-info
    libliftoff
    hwdata
    seatd
    pcre2
    xwayland-satellite
    zsh-powerlevel10k
    swww
    jq
    btop
    stow
    _7zz
    brave
    libreoffice
    kdePackages.okular
  ];
  
  # Enabling zsh as a shell
  programs.zsh.enable = true;
  programs.zsh.promptInit = ''
    source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
  '';

  # Set wallpaper on boot
  systemd.user.services.wallpaper = {
    description = "Set wallpaper for niri";
    after = [ "graphical-session.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon & sleep 1 & ${pkgs.swww}/bin/swww img -o eDP-1 /home/antonio/Images/Wallpapers/stars.jpg";
      Restart = "on-failure";
    };

    wantedBy = [ "graphical-session.target" ];
  };
  
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # Do NOT change this line, could BREAK  the system
  system.stateVersion = "25.11";

}

