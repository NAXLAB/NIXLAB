{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [ inputs.punktfunk.nixosModules.default ];

  nix.settings = {
    extra-substituters = [ "https://nix.unom.io" ];
    extra-trusted-public-keys = [
      "punktfunk-cache-1:yhOJmHxzg6tzXpxSFzlYn6Pc6r0jHprsWqt8MZC654o="
    ];
  };

  services.punktfunk.host.enable = true;
}