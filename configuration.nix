# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

let jdkEnvironments = pkgs.runCommand "jdk-env" { 
  buildInputs = with pkgs; [ zulu8 zulu17 zulu21];
  } ''
    mkdir -p $out/jdks
    ln -s ${pkgs.zulu8}		$out/jdks/zulu8
    ln -s ${pkgs.zulu17}	$out/jdks/zulu17
    ln -s ${pkgs.zulu21}	$out/jdks/zulu21
  '';
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
    "/.swapvol".options = [ "noatime" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.initrd.kernelModules = [ "nvidia" "i915" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  networking = {
    firewall = {
  enable = true;
  allowedTCPPorts = [ 43301 ];
  allowedUDPPortRanges = [
    {from = 43301; to = 43301;}
  ];};
  };
  
  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
    };
  };
 # networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Asia/Tokyo";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  #securityConf
  security.polkit.enable = true;
  security.sudo = {
    extraRules = [{ users = ["amaiice"]; commands = [ "ALL" "SETENV" "NOPASSWD" ];}];
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "ja_JP.UTF-8";
  console = {
     # font = "Lat2-Terminus16";
     keyMap = "jp106";
  };

  #nixpkgsの設定.
  nixpkgs.config = {
    pulseaudio = true;
    nvidia.acceptLicense = true;
    packageOverrides =  pkgs: { inherit (pkgs) linuxPackages_latest nvidia_x11;};
    allowUnfree = true;
  };
  


  # グラフィック設定.
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    nvidiaSettings = true;
    open=true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # Enable the X11 windowing system.
  services.displayManager = {
    defaultSession = "hyprland";
  };
  
  # enable Universal Wayland Session Manager.
  programs = {
    uwsm = {
      enable = true;
    };

    hyprland = {
      enable = true;
      withUWSM = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    
    adb = {
      enable = true;
    };

    git = {
      enable = true;
    };

    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };

    fish = {
      enable = true;
      interactiveShellInit = "set fish_greeting;fastfetch;starship init fish | source";
    };

    starship = {
      enable = true;
      settings = {
        format = "$os:$username@$hostname $directory>";

        username = {
          style_user = "green bold";
          style_root = "red bold";
          format = "[$user]($style)";
          show_always = true;
        };

        hostname = {
          ssh_only = false;
          format = "[$ssh_symbol$hostname](bold white)";
        };

        os = {
          disabled = false;
          format = "[$symbol]($style)";
          style = "bold cyan";
        };
      };
    };
  };
 
  users.users.amaiice = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "adbusers" "wheel" "realtime" ];
  };
    services.udev.packages = [
    pkgs.android-udev-rules
  ];

  services = {
    wivrn = {
      enable = true;
      openFirewall = true;
    };
  };

  services.udev.extraRules = ''
SUBSYSTEMS=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666", GROUP="plugdev" 
  '';
/*
  programs.alvr = {
  enable = true;
  package = unstable.alvr;
  openFirewall = true;
};*/

  environment.pathsToLink = [ "/jdks" ];
  environment.systemPackages = with pkgs; [
    starship
    usbutils
    firefox
    alacritty
    wl-clipboard
    sidequest
    lunarvim
    hyprshot
    
    # /run/current-system/sw/jdks 配下にjdkファイルが生成される.
    jdkEnvironments
  ];

  environment.variables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx5";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };
 

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

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

  # programs.firefox.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}

