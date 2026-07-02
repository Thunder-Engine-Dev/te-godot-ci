FROM ubuntu:noble
LABEL author="https://github.com/aBARICHELLO/godot-ci/graphs/contributors"

USER root
SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    git \
    git-lfs \
    unzip \
    wget \
    curl \
    zip \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# When in doubt, see the downloads page: https://github.com/godotengine/godot-builds/releases/
ARG GODOT_VERSION="4.7.1"

# Example values: stable, beta3, rc1, dev2, etc.
# Also change the `SUBDIR` argument below when NOT using stable.
ARG RELEASE_NAME="rc"

# This is only needed for non-stable builds (alpha, beta, RC)
# e.g. SUBDIR "/beta3"
# Use an empty string "" when the RELEASE_NAME is "stable".
ARG SUBDIR=""

ARG GODOT_TEST_ARGS=""
ARG GODOT_PLATFORM="linuxbsd"

RUN wget https://github.com/Thunder-Engine-Dev/godot-te/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/godot.${GODOT_PLATFORM}.editor.x86_64.zip \
    && wget https://github.com/Thunder-Engine-Dev/godot-te/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/godot.${GODOT_PLATFORM}.template_release.x86_64.zip \
    && wget https://github.com/Thunder-Engine-Dev/godot-te/releases/download/${GODOT_VERSION}-${RELEASE_NAME}/godot.windows.template_release.x86_64.zip \
    && mkdir -p ~/.cache \
    && mkdir -p ~/.config/godot \
    && mkdir -p ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && unzip godot.${GODOT_PLATFORM}.editor.x86_64.zip \
    && chmod +x godot.${GODOT_PLATFORM}.editor.x86_64 \
    && mv godot.${GODOT_PLATFORM}.editor.x86_64 /usr/local/bin/godot \
    && unzip godot.${GODOT_PLATFORM}.template_release.x86_64.zip \
    && unzip godot.windows.template_release.x86_64.zip \
    && mv godot.windows.template_release.x86_64.exe ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && chmod +x godot.${GODOT_PLATFORM}.template_release.x86_64 \
    && mv godot.${GODOT_PLATFORM}.template_release.x86_64 ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME} \
    && rm -f godot.${GODOT_PLATFORM}.template_release.x86_64.zip godot.windows.template_release.x86_64.zip godot.${GODOT_PLATFORM}.editor.x86_64.zip \
    && cd ~/.local/share/godot/export_templates/${GODOT_VERSION}.${RELEASE_NAME}


RUN godot -v -e --quit --headless ${GODOT_TEST_ARGS}
# Godot editor settings are stored per minor version since 4.3.
# `${GODOT_VERSION:0:3}` transforms a string of the form `x.y.z` into `x.y`, even if it's already `x.y` (until Godot 4.9).
RUN echo '[gd_resource type="EditorSettings" format=3]' > ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
RUN echo '[resource]' >> ~/.config/godot/editor_settings-${GODOT_VERSION:0:3}.tres
