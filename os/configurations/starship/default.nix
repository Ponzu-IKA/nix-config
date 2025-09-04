{ pkgs, ... }:
{
  imports = [
    ./settings.nix
    ./fish-integrations.nix
  ];
  
  environment.systemPackages = with pkgs; [
    starship
    fish
  ];

}
