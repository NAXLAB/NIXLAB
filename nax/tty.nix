{ colors, ... }:
let c = colors.colors;
in {
  console.colors = [
    c.base00 c.base08 c.base0B c.base0A
    c.base0D c.base0E c.base0C c.base05
    c.base03 c.base08 c.base0B c.base0A
    c.base0D c.base0E c.base0C c.base07
  ];
}