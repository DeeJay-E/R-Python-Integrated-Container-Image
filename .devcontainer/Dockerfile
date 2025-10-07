# Use Ubuntu 24.04 with CUDA 12.6 (supports Python 3.12 natively)
# Note: CUDA 12.4 images for Ubuntu 24.04 may not be available, using 12.6
FROM nvidia/cuda:12.6.0-devel-ubuntu24.04

ARG USERNAME=developer
ARG GROUPNAME=$USERNAME
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create the user; adapted from:
# https://code.visualstudio.com/remote/advancedcontainers/add-nonroot-user
RUN groupadd -f $USERNAME \
    && useradd -m -s /bin/bash -g $GROUPNAME $USERNAME \
    && apt-get update \
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# ********************************************************
# * Anything else you want to do like clean up goes here *
# ********************************************************

# [Optional] Set the default user. Omit if you want to keep the default as root.
USER $USERNAME
