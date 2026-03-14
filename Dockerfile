FROM ubuntu:22.04

# Setze nicht-interaktive Installation
ENV DEBIAN_FRONTEND=noninteractive

# Installiere Abhängigkeiten
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Setze Java Home
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Installiere Flutter
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin"

# Flutter Precache
RUN flutter precache

# Akzeptiere Android Lizenzen
RUN yes | flutter doctor --android-licenses

# Arbeitsverzeichnis
WORKDIR /app

# Kopiere Projektdateien
COPY . .

# Installiere Abhängigkeiten
RUN flutter pub get

# Generiere Hive Adapter
RUN flutter pub run build_runner build --delete-conflicting-outputs

# Baue APK
RUN flutter build apk --release

# APK verfügbar machen
VOLUME ["/app/build/app/outputs/flutter-apk"]

CMD ["bash", "-c", "echo '✅ APK gebaut: /app/build/app/outputs/flutter-apk/app-release.apk' && sleep infinity"]