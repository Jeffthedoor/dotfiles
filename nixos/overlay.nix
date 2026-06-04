final: prev:
let
  bluezVersion = "5.85";
  bluezSource = prev.fetchurl {
    url = "mirror://kernel/linux/bluetooth/bluez-${bluezVersion}.tar.xz";
    hash = "sha256-rQKOSSVLxFUaE/CP55BMY9ArplDXe+iuFbs7CgrZSm8=";
  };
in
{ 
  "bluez-headers" = prev."bluez-headers".overrideAttrs (_old: {
    version = bluezVersion;
    src = bluezSource;
  });

  bluez = prev.bluez.overrideAttrs (_old: {
    version = bluezVersion;
    src = bluezSource;
  });
}
