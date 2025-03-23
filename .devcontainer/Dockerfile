FROM gitpod/workspace-full-vnc

# Dependences for chrome
RUN sudo apt-get update \
 && sudo DEBIAN_FRONTEND=noninteractive apt-get install -y \
   libgtk2.0-0 \
   libgtk-3-0 \
   libnotify-dev \
   libgconf-2-4 \
   libnss3 \
   libxss1 \
   libasound2 \
   libxtst6 \
   xauth \
   xvfb \
   curl git unzip xz-utils zip libglu1-mesa \
   clang cmake git  ninja-build pkg-config \
   libgtk-3-dev liblzma-dev libstdc++-12-dev \
 && sudo rm -rf /var/lib/apt/lists/*

# Download and install flutter 
ENV FLUTTER_VERSION=3.29.0-stable
RUN wget -q "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz" -O - | tar xpJ -C "$HOME"
ENV PATH="$HOME/flutter/bin:$PATH"
RUN flutter doctor
