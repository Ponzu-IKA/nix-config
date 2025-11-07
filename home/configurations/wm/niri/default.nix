{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ironbar
    hicolor-icon-theme
  ];

  programs = {
    fuzzel.enable = true;
  };

  services.dunst = {
    enable = true;
    settings = {
    	global = {
	    follow = "mouse";
	    indicate_hidden = "yes";
	    geometry = "300x30-5+60";
	    shrink = "no";
	    transparency = 0;
	    frame_color = "#4287f5";
	    frame_width = 1;
	    markup = "full";
	    format = "<b>%a</b> - <i>%s</i>\n%b";
	};
    };
  };
}
