{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./fish-integrations.nix
  ];
  
  programs = {
    starship.enable = true;
    fish.enable = true;
  };

}
