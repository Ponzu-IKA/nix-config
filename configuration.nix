# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [
      "compress=zstd"
      "noatime"
    ];
    "/.swapvol".options = [ "noatime" ];
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_xanmod;
  boot.initrd.kernelModules = [
    "nvidia"
    "i915"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];
  zramSwap.enable = true;

  networking = {
    hostName = "nixos";
    hosts = {
      "192.168.10.57" = [
        "homelab-pve.local"
      ];
    };

    firewall = {
      enable = true;
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedTCPPorts = [
        8006
        9090
        5037
        3000
      ];
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
    interfaces.enp4s0 = {
      ipv4.addresses = [
        {
          address = "192.168.10.128";
          prefixLength = 24;
        }
      ];
    };
    defaultGateway = {
      address = "192.168.10.1";
      interface = "enp4s0";
    };
    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
    ];

  };

  nix = {
    settings = {
      auto-optimise-store = true; # nix storeの最適化.
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };

    #7日ごとにgcを実行する.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
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
    extraConfig = ''Defaults lecture = "always"'';
    extraRules = [
      {
        users = [ "amaiice" ];
        commands = [
          "ALL"
          "SETENV"
          "NOPASSWD"
        ];
      }
    ];
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
    packageOverrides = pkgs: { inherit (pkgs) linuxPackages_latest nvidia_x11; };
    allowUnfree = true; # 企業系パッケージの有効化
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
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # nixpkgs.config.cudaSupport = true;

  # Enable the X11 windowing system.
  services.displayManager = {
    ly = {
      enable = true;
    };
    #sddm = {
    # wayland.enable = true;
    #};

  };

  # enable Universal Wayland Session Manager.
  programs = {
    fuse = {
      enable = true;
    };
    niri = {
      enable = true;
    };

    hyprland = {
      enable = false;
      xwayland.enable = true;
      withUWSM = false;
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
  };

  users.users.amaiice = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"
      "wheel"
      "realtime"
      "input"
    ];
  };
  services.udev.packages = [
  ];

  services = {
    wivrn = {
      enable = true;

      package = pkgs.wivrn.override {
        cudaSupport = true;
      };

      openFirewall = true;
      autoStart = true;
      config.json = {
        application = [ pkgs.wlx-overlay-s ];
      };
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
    };
  */

  environment.pathsToLink = [ "/jdks" ];
  environment.systemPackages = with pkgs; [
    direnv
    perf
    gnupg

    cloudflared
    pulseaudio
    starship
    usbutils
    firefox
    wl-clipboard
    sidequest
    lunarvim
    xwayland-satellite
    xdg-desktop-portal-gtk
    xdg-desktop-portal-gnome

    #glfw
    xrandr
    xorg.libX11
    xorg.libXcursor
    libx11
    libxcursor
    libxrandr
    libxxf86vm
    xorg.libXi
    libGL
    glfw3-minecraft
    openal
    pciutils
    mesa-demos

    rust-analyzer

    ffmpeg-full
    cudaPackages.cudatoolkit
  ];

  environment.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = "1";
  };

  environment.variables = {
    GTK_IM_MODULE = "fcitx5";
    QT_IM_MODULE = "fcitx5";
    XMODIFIERS = "@im=fcitx5";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  programs.nix-ld = {
    enable = true;
    # From https://github.com/NixOS/nixpkgs/issues/240444#issuecomment-1988645885
    libraries = with pkgs; [
      desktop-file-utils
      xorg.libXcomposite
      xorg.libXtst
      xorg.libXrandr
      xorg.libXext
      xorg.libX11
      xorg.libXfixes
      libGL
      libGLU
      glfw
      mesa
      #libglvnd

      gst_all_1.gstreamer
      gst_all_1.gst-plugins-ugly
      gst_all_1.gst-plugins-base
      libdrm
      xorg.xkeyboardconfig
      xorg.libpciaccess

      glib
      gtk2
      bzip2
      zlib
      gdk-pixbuf

      xorg.libXinerama
      xorg.libXdamage
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libXxf86vm
      xorg.libXi
      xorg.libSM
      xorg.libICE
      freetype
      curlWithGnuTls
      nspr
      nss
      fontconfig
      cairo
      pango
      expat
      dbus
      cups
      libcap
      SDL2
      libusb1
      udev
      dbus-glib
      atk
      at-spi2-atk
      libudev0-shim

      xorg.libXt
      xorg.libXmu
      xorg.libxcb
      xorg.xcbutil
      xorg.xcbutilwm
      xorg.xcbutilimage
      xorg.xcbutilkeysyms
      xorg.xcbutilrenderutil
      libGLU
      libuuid
      libogg
      libvorbis
      SDL
      SDL2_image
      glew110
      openssl
      libidn
      tbb
      wayland
      mesa
      libxkbcommon
      vulkan-loader

      flac
      freeglut
      libjpeg
      libpng12
      libpulseaudio
      libsamplerate
      libmikmod
      libthai
      libtheora
      libtiff
      pixman
      speex
      SDL_image
      SDL_mixer
      SDL2_ttf
      SDL2_mixer
      libappindicator-gtk2
      libcaca
      libcanberra
      libgcrypt
      libvpx
      librsvg
      xorg.libXft
      libvdpau
      alsa-lib

      harfbuzz
      e2fsprogs
      libgpg-error
      keyutils.lib
      libjack2
      fribidi
      p11-kit

      gmp

      # used by hyprpanel
      libgtop

      # libraries not on the upstream include list, but nevertheless expected
      # by at least one appimage
      libtool.lib # for Synfigstudio
      xorg.libxshmfence # for apple-music-electron
      at-spi2-core
      pciutils # for FreeCAD
      pipewire # immersed-vr wayland support
    ];
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
