{ fetchzip
, fetchurl
, openjdk19
, zip
, unzip
, writeScriptBin
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

  java = "${openjdk19}/bin/java";
in writeScriptBin "aurora-setup" ''
  mkdir -p tmp/{strip,deobf,decomp}
  mkdir -p src/main/{java,resources}

  ${unzip}/bin/unzip ${server-jar} -d tmp/strip
  rm -rf tmp/strip/{com,io,javax,org,META-INF}
  mv tmp/strip/{Log4j-*,log4j2.xml,yggdrasil_session_pubkey.der} src/main/resources
  cd tmp/strip
  ${zip}/bin/zip -r server.jar *
  cd ../..

  ${java} -jar ${special-source} --in-jar tmp/strip/server.jar --out-jar tmp/deobf/server.jar --srg-in ${mcp}/conf/joined.srg --kill-lvt
  ${java} -jar ${fernflower} tmp/deobf/server.jar tmp/decomp
  ${unzip}/bin/unzip tmp/decomp/server.jar -d src/main/java
''
