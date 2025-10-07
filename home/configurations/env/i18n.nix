{ pkgs, ... }:
{
  i18n.inputMethod = {
    type = "fcitx5";
    enable = true;
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      kdePackages.fcitx5-qt
      fcitx5-configtool
    ];
  };
}
