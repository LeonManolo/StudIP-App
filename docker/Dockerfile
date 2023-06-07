FROM ubuntu:latest

ENV UID=1000
ENV GID=1000
ENV USER="developer"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_URL="https://github.com/flutter/flutter.git"
ENV FLUTTER_VERSION="3.10.0"
ENV ANDROID_HOME="/home/$USER/Android/Sdk"
ENV ANDROID_TOOLS_URL="https://dl.google.com/android/repository/commandlinetools-linux-6609375_latest.zip"
ENV PATH="$ANDROID_HOME/cmdline-tools/latest:$ANDROID_HOME:$FLUTTER_HOME/bin:$PATH"

RUN apt update \
  && apt install -y android-sdk cmake ninja-build sudo clang libgtk-3-dev git curl ca-certificates unzip

RUN groupadd --gid $GID $USER \
  && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
  && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER

# Android SDK
RUN mkdir -p $ANDROID_HOME \
  && sudo mv /usr/lib/android-sdk/* $ANDROID_HOME \
  && sudo chown $USER:$USER -R $ANDROID_HOME \
  && rm -r $ANDROID_HOME/build-tools \
  && curl -o android_tools.zip $ANDROID_TOOLS_URL \
  && unzip android_tools.zip \
  && mkdir -p "$ANDROID_HOME/cmdline-tools/latest" \
  && mv tools/* "$ANDROID_HOME/cmdline-tools/latest/" \
  && yes | ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses \
  && ${ANDROID_HOME}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_HOME} --install "build-tools;30.0.3" "platforms;android-31" "platforms;android-313"

# Install Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable \
  && flutter upgrade \
  && flutter config --android-sdk "$ANDROID_HOME" \
  && yes | flutter doctor --android-licenses \
  && flutter doctor