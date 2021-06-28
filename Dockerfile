# syntax=docker/dockerfile:1
# ================================
# Build image
# ================================
FROM hendesi/master-thesis:offical-swift-arm as build
# FROM swiftlang/swift:nightly-5.5-focal as build
# FROM hendesi/master-thesis:swift-5.4 as build

# Install OS updates and, if needed, sqlite3
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && export QEMU_CPU=max \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && rm -rf /var/lib/apt/lists/*

# Set up a build area
WORKDIR /build

# Copy all source files
COPY . .

# Build everything, with optimizations and test discovery
RUN swift build -Xswiftc -Xfrontend -Xswiftc -sil-verify-none -c debug -j 1 -v

WORKDIR /staging

RUN cp "$(swift build -c debug --package-path /build --show-bin-path)/TestWebService" ./

FROM hendesi/master-thesis:offical-swift-arm
# FROM hendesi/master-thesis:swift-5.4
# FROM swiftlang/swift:nightly-5.5-focal

# Make sure all system packages are up to date.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && rm -r /var/lib/apt/lists/*

# Create a apodini user and group with /app as its home directory
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app apodini

WORKDIR /app

COPY --from=build --chown=apodini:apodini /staging /app

USER apodini:apodini

ENTRYPOINT ["./TestWebService"]
