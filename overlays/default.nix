final: prev: {

  adguardhome = prev.adguardhome.overrideAttrs (oldAttrs: {
    src = prev.fetchurl {
      url =
        "https://github.com/AdguardTeam/AdGuardHome/releases/download/v0.106.3/AdGuardHome_linux_arm64.tar.gz";
      sha512 =
        "sha512:3n3g7yhg40128vzip40q2hi7c7k2jw089cymqlrh5krlvc2lf6sm1an3y5p42nav181qagb7i9v7a3s38l16jcmsaf9fby52ncgvzfz";
    };
  });

  changedetection.io = prev.callPackage ./changedetection.io { };

}
