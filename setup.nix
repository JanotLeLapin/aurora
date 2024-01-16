{ stdenv
, fetchzip
, fetchurl
, openjdk19
, unzip
}: let
  server-jar = fetchurl {
    url = "https://launcher.mojang.com/v1/objects/b58b2ceb36e01bcd8dbf49c8fb66c55a9f0676cd/server.jar";
    hash = "sha256-wY5CRQc6r/WA63NZkC8CUUNlaLFkep5EOpJM23P6gxI=";
  };

  mcp = fetchzip {
    url = "http://www.modcoderpack.com/files/mcp918.zip";
    hash = "sha256-/eUB5VsCP131zJIGNngSlow2V53A0/Oo42T/UprIJbg=";
    stripRoot = false;
  };

  special-source = let version = "1.11.3"; in fetchurl {
    url = "https://repo1.maven.org/maven2/net/md-5/SpecialSource/${version}/SpecialSource-${version}-shaded.jar";
    hash = "sha256-O8H5DDBlT7I3sC5oyQ+xz1qYWQ8Cisw/92bxI+DTWNw=";
  };
  fernflower = let version = "233.13135.103"; in fetchurl {
    url = "https://www.jetbrains.com/intellij-repository/releases/com/jetbrains/intellij/java/java-decompiler-engine/${version}/java-decompiler-engine-${version}.jar";
    hash = "sha256-pVeBfdLevRtlP5R02IksfjQTe1o50+WY1A4599aiCCU=";
  };
in stdenv.mkDerivation {
  name = "mc-server-sources";
  dontUnpack = true;
  buildInputs = [ openjdk19 unzip ];
  buildPhase = ''
    mkdir decomp out
    java -jar ${special-source} --in-jar ${server-jar} --out-jar deobf.jar --srg-in ${mcp}/conf/joined.srg --kill-lvt
    java -jar ${fernflower} deobf.jar decomp
    unzip decomp/*.jar -d out
  '';
  installPhase = ''
    mv out $out
  '';
}
