  GNU nano 6.2                                                                                                                            Dockerfile                                                                                                                                      
FROM arm64v8/ubuntu:latest

ENV UID=1000
ENV GID=1000
ENV USER="developer"
ENV FLUTTER_HOME="/home/$USER/flutter"
ENV FLUTTER_URL="https://github.com/flutter/flutter.git"

ENV PATH="$FLUTTER_HOME/bin:$PATH"

RUN apt update \
    && apt install -y cmake ninja-build sudo clang libgtk-3-dev git curl unzip

RUN groupadd --gid $GID $USER \
    && useradd -s /bin/bash --uid $UID --gid $GID -m $USER \
    && echo $USER ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USER \
    && chmod 0440 /etc/sudoers.d/$USER

USER $USER
WORKDIR /home/$USER


RUN git clone https://github.com/flutter/flutter.git -b stable \
  && flutter doctor \
  && flutter update-packages


