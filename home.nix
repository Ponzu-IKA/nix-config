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
    fastfetch
    bottom
    fish
    kdePackages.dolphin
    hyprpolkitagent
    git
    lazygit
    gparted
    yt-dlp
    vlc
    krita
    prismlauncher-unwrapped
    
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
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    settings = {
      "$mod" = "SUPER";
      "$terminal" = "alacritty";
      "$fileManager" = "dolphin";
      "$menu" = "wofi --show drun";
      
      decoration = {
        rounding = 0;
	
	active_opacity = 0.95;
	inactive_opacity = 0.85;

	shadow = {
	  enabled = true;
	  range = 4;
	  render_power = 3;
	  color = "rgba(1a1a1aee)";
	};

	blur = {
          enabled = true;
	  size = 3;
	  passes = 1;

	  vibrancy = 0.1696;
	};
      };

      animations = {
        enabled = "no";
      };

      dwindle = {
        pseudotile = true;
	preserve_split = true;
      };

      master = {
        new_status = "master";
      };

      general = {
        gaps_in = 0;
	gaps_out = 0;
	border_size = 2;

	"col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
	"col.inactive_border" = "rgba(595959aa)";

	resize_on_border = false;
	allow_tearing = false;
        layout = "dwindle";
      };
      input = {
        kb_layout = "jp";
	follow_mouse = 1;

	sensitivity = 0;
      };
      bind = [
        "$mod, Return, exec, $terminal"
	"$mod, Q, killactive"
	"$mod, R, exec, $menu"
	"$mod, F, togglefloating"
	"$mod, E, exec, $fileManager"
	"$mod, P, pseudo"
	"$mod, J, togglesplit"

	# 操作画面を矢印キーで変更.
	"$mod, left, movefocus, l"
	"$mod, right, movefocus, r"
	"$mod, up, movefocus, u"
	"$mod, down, movefocus, d"

	# ワークスペースの変更.
	"$mod, 1, workspace, 1"
	"$mod, 2, workspace, 2"
	"$mod, 3, workspace, 3"
	"$mod, 4, workspace, 4"
	"$mod, 5, workspace, 5"
	"$mod, 6, workspace, 6"
	"$mod, 7, workspace, 7"
	"$mod, 8, workspace, 8"
	"$mod, 9, workspace, 9"
	"$mod, 0, workspace, 10"

	# アクティブなウィンドウと一緒にワークスペースを移動.
	"$mod SHIFT, 1, movetoworkspace, 1"
	"$mod SHIFT, 2, movetoworkspace, 2"
	"$mod SHIFT, 3, movetoworkspace, 3"
	"$mod SHIFT, 4, movetoworkspace, 4"
	"$mod SHIFT, 5, movetoworkspace, 5"
	"$mod SHIFT, 6, movetoworkspace, 6"
	"$mod SHIFT, 7, movetoworkspace, 7"
	"$mod SHIFT, 8, movetoworkspace, 8"
	"$mod SHIFT, 9, movetoworkspace, 9"
	"$mod SHIFT, 0, movetoworkspace, 10"

	# ｽﾍﾟｼｬﾙ！なワークスペースに移動(基本ワークスペースの上にあるワークスペース)
	"$mod, S, togglespecialworkspace, magic"
	"$mod SHIFT, S, movetoworkspace, special:magic" #ｽﾍﾟｼｬﾙ!に移動させるﾏｼﾞｯｸ!      
      ];
      bindm = [
        "$mod, mouse:272, movewindow"
	"$mod, mouse:273, resizewindow"
      ];
      
      windowrule = "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0";
    };
  };
    xdg.configFile."uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  /*
  xdg.portal = {
    enable = lib.mkForce true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };*/

  home.file = {
  };
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
