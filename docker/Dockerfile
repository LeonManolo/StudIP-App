FROM ubuntu:latest

ENV UID=1000
ENV GID=1000
ENV USER="developer"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_URL="https://github.com/flutter/flutter.git"
ENV FLUTTER_VERSION="3.10.0"

ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN apt update \
    && apt install -y cmake ninja-build sudo clang libgtk-3-dev git curl ca-certificates unzip

RUN groupadd --gid $GID $USER \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable \
  && flutter upgrade \
  && flutter doctor \
  && flutter config --enable-linux-desktop

# Patch flutter engine with glsl shaders
RUN mkdir tmp \
  && cd tmp \
  && curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_$FLUTTER_VERSION-stable.tar.xz \
  && tar -xvf flutter_linux_$FLUTTER_VERSION-stable.tar.xz flutter/bin/cache/artifacts/engine/linux-x64/shader_lib \
  && cp -R flutter/bin/cache/artifacts/engine/linux-x64/shader_lib $FLUTTER_HOME/bin/cache/artifacts/engine/linux-arm64 \
  && rm -r ./*


