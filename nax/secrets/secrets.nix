let
  zaigomaat = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINTX6zJfqYMCy9ydyfqyV6qnf5wz0l+zvW29mAu9gZsU root@zaigomaat";
in
{
  "xdrive.age".publicKeys     = [ zaigomaat ];
  "smb.age".publicKeys  = [ zaigomaat ];
  "github.age".publicKeys = [ zaigomaat ];
}