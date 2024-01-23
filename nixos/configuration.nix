# Edit this configuration file to ine what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
    ./hw/hardware-configuration.nix
    #     ./users/eino.nix
    ];
    users.users.eino.isNormalUser = true;
    users.users.eino.extraGroups = [ "networkmanager" "wheel" "docker" "vboxusers" ];
    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    virtualisation.virtualbox.host.enable = true;
    virtualisation.virtualbox.guest.enable = true;
    security.polkit.enable = true;
    hardware.opengl.enable = true;
    # Setup keyfile
    boot.initrd.secrets = {
      "/crypto_keyfile.bin" = null;
    };

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    virtualisation.docker.enable = true;
    # Enable network manager applet
    programs.nm-applet.enable = true;
    # bluetooth

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    # Set your time zone.
    time.timeZone = "Europe/Helsinki";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_US.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "fi_FI.UTF-8";
      LC_IDENTIFICATION = "fi_FI.UTF-8";
      LC_MEASUREMENT = "fi_FI.UTF-8";
      LC_MONETARY = "fi_FI.UTF-8";
      LC_NAME = "fi_FI.UTF-8";
      LC_NUMERIC = "fi_FI.UTF-8";
      LC_PAPER = "fi_FI.UTF-8";
      LC_TELEPHONE = "fi_FI.UTF-8";
      LC_TIME = "fi_FI.UTF-8";
    };

    # Enable the X11 windowing system
    services.xserver.enable = true;

    # Enable the MATE Desktop Environment
    services.xserver.displayManager.lightdm.enable = true;
    services.xserver.desktopManager.mate.enable = false;
    #services.xserver.windowManager.dwm.enable = true;
    # Configure keymap in X11
    services.xserver = {
      layout = "fi";
      xkbVariant = "";
      windowManager.icewm.enable = true;
      windowManager.default = "icewm";
      videoDrivers = [ "modesetting" ]; 
    };
    # Configure console keymap
    console.keyMap = "fi";

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
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;  
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    nixpkgs.config.permittedInsecurePackages = [
        "nodejs-14.21.3"
        "openssl-1.1.1v"
    ];
    environment.systemPackages = with pkgs; [
      vim
      wget
      emacs29
      nodejs_14
      xterm
      st
      dmenu
      python3
      vcv-rack
      guitarix
      rakarrack
      hydrogen
      qjackctl
      qsynth
      polyphone
      ffmpeg
      rosegarden
      ardour
      (python38.withPackages(ps: with ps; [ pandas requests configparser pygame mido pyaudio pydub ]))
    ];
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
      #   enable = true;
      #   enableSSHSupport = true;
      # };

      # List services that you want to enable:

      # Enable the OpenSSH daemon.
      services.openssh = {
        enable = true;
        settings.PasswordAuthentication = true;
        settings.KbdInteractiveAuthentication = true;
       };

      # Open ports in the firewall.
       networking.firewall.allowedTCPPorts = [ 22 ];
       networking.firewall.allowedUDPPorts = [ 22 ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "23.05"; # Did you read the comment?

}
