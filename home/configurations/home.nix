{ config, pkgs, lib, ... }:


{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord"
  ];
 # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home = {
    username = "amaiice";
    homeDirectory = "/home/amaiice";
  };
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
    home.packages = with pkgs; [
    discord
    wofi
    bottom
    kdePackages.dolphin
    lazygit
    gparted
    yt-dlp
    vlc
    krita
       
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = {
      sansSerif = [ "Noto Sans CJK JP" ];
      monospace = [ "JetBrainsMono Nerd Font" ];
      emoji = [ "Noto Color Emoji" ];
    };
  };

  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs;[
      fcitx5-mozc
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      kdePackages.fcitx5-qt
      fcitx5-configtool
    ];
  };

  # HyprlandWM
    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  /*
  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };*/

/*
  home.sessionVariables = {
    # EDITOR = "emacs";
    GTK_IM_MODULE	= "fcitx5";
    QT_IM_MODULE	= "fcitx5";
    XMODIFIERS		= lib.mkForce "@im=fcitx5";
  };
*/
  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
  };
}
