#Secrets.nix
#Setup Key: cat /etc/ssh/ssh_host_ed25519_key.pub
#agenix -e secret.age

let
  zaigomaat = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPkKtMA4MchOVFAgpMT5tDQTFywg4+ctfsOEtcFnTW+7 root@zaigomaat";
in
{
  "xdrive.age".publicKeys     = [ zaigomaat ];
  "smb.age".publicKeys  = [ zaigomaat ];
}