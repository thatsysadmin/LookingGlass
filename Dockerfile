FROM fedora:36 AS lookingglass_build

RUN dnf update -y
RUN dnf install -y cmake gcc gcc-c++ libglvnd-devel fontconfig-devel spice-protocol make nettle-devel \
        pkgconf-pkg-config binutils-devel libXi-devel libXinerama-devel libXcursor-devel \
        libXpresent-devel libxkbcommon-x11-devel wayland-devel wayland-protocols-devel \
        libXScrnSaver-devel libXrandr-devel dejavu-sans-mono-fonts
RUN dnf install -y pipewire-devel libsamplerate-devel pulseaudio-libs-devel libsamplerate-devel
RUN dnf install -y git
COPY . /LookingGlass
WORKDIR /LookingGlass
ENTRYPOINT bash /LookingGlass/build.sh