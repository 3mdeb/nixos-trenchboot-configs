# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./cachix.nix
      ./linux-5.5.nix
    ];

  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
  # Automatically add boot entry to UEFI boot order.
  boot.loader.efi = {
    canTouchEfiVariables = true;
  };
  boot.loader.grub = {
    enable = true;
    copyKernels = true;
    efiInstallAsRemovable = false;
    efiSupport = true;
    fsIdentifier = "uuid";
    splashMode = "stretch";
    version = 2;
    device = "nodev";
    extraEntries = ''
      menuentry "NixOS - Secure Launch" {
        --set=drive1 --fs-uuid 4881-6D27
        slaunch skinit
        slaunch_module ($drive1)//lz_header
        linux ($drive1)//kernels/3w98shnz1a6nxpqn2wwn728mr12dy3kz-linux-5.5.3-bzImage systemConfig=/nix/store/ci38is4cvjlz528jay66h7qpqr6ws22n-nixos-system-nixos-20.09.git.c156a866dd7M init=/nix/store/ci38is4cvjlz528jay66h7qpqr6ws22n-nixos-system-nixos-20.09.git.c156a866dd7M/init console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 console=tty0 loglevel=4
        initrd ($drive1)//kernels/k1x969q4mwj59hyq3hn2mcxck8s2410a-initrd-linux-5.5.3-initrd
      }
      menuentry "Reboot" {
        reboot      
      }
      menuentry "Poweroff" {
        halt
      }
    '';
  };
  boot.kernelParams = [ "console=ttyS0,115200 earlyprintk=serial,ttyS0,115200 console=tty0" ];
  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.eno1.useDHCP = true;
  networking.interfaces.eno2.useDHCP = true;
  networking.interfaces.eno3.useDHCP = true;
  networking.interfaces.eno4.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  # time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  #   pinentryFlavor = "gnome3";
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  # services.xserver.libinput.enable = true;

  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.03"; # Did you read the comment?


  # OS utilities
  environment.systemPackages = [
                                 pkgs.pkg-config
                                 pkgs.git
                                 pkgs.gnumake
                                 pkgs.autoconf
                                 pkgs.automake
                                 pkgs.gettext
                                 pkgs.python
                                 pkgs.m4
                                 pkgs.libtool
                                 pkgs.bison
                                 pkgs.flex
                                 pkgs.gcc
                                 pkgs.gcc_multi
                                 pkgs.libusb
                                 pkgs.ncurses
                                 pkgs.freetype
                                 pkgs.qemu
                                 pkgs.lvm2
                                 pkgs.unifont
                                 pkgs.fuse
                                 pkgs.gnulib
                                 pkgs.stdenv
                                 pkgs.nasm
                                 pkgs.binutils
                                 pkgs.tpm2-tools
                                 pkgs.tpm2-tss
                                 pkgs.landing-zone
                                 pkgs.landing-zone-debug
                                 pkgs.grub-tb-efi
                                ];

  # Grub override
  nixpkgs.config.packageOverrides = pkgs: { grub2 = pkgs.grub-tb-efi; };
}
