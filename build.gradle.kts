plugins {
    application
}

repositories {
    mavenCentral()
}

dependencies {
    implementation("io.netty:netty-all:4.0.33.Final")
    implementation("com.google.guava:guava:18.0")
    implementation("com.google.code.gson:gson:2.5")
    implementation("com.google.code.findbugs:jsr305:3.0.2")
    implementation("commons-io:commons-io:2.4")
    implementation("org.apache.commons:commons-lang3:3.4")
    implementation("commons-codec:commons-codec:1.10")
    implementation("org.apache.logging.log4j:log4j-core:2.3")
}

java {
    toolchain {
        languageVersion.set(JavaLanguageVersion.of(8))
    }
}

application {
    mainClass.set("net.minecraft.server.MinecraftServer")
}
