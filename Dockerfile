FROM cirrusci/flutter:latest

# Install essential Linux desktop dependencies
RUN apt-get update && apt-get install -y \
    libgtk-3-dev \
    clang \
    cmake \
    ninja-build \
    libblkid-dev \
    liblzma-dev \
    libglu1-mesa \
  && rm -rf /var/lib/apt/lists/*

# Setup project directory (will be overridden by mount)
WORKDIR /app
