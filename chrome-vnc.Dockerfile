# Use a lightweight base image
FROM --platform=linux/amd64 ubuntu:24.04

# Set environment variables to avoid prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99
ENV CHROME_VERSION="google-chrome-stable"
ENV XDG_RUNTIME_DIR=/tmp
ENV DBUS_SYSTEM_BUS_ADDRESS=unix:path=/var/run/dbus/system_bus_socket

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y wget gnupg x11vnc xvfb fluxbox dbus iptables libnss3-tools && \
    apt-get clean

# Set the Chrome repo.
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'

# Install Chrome.
RUN apt-get update && apt-get install -y $CHROME_VERSION

# Set up VNC server with a fixed password
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd 'password' ~/.vnc/passwd

RUN mkdir mkdir -p $HOME/.pki/nssdb
RUN certutil -N -d $HOME/.pki/nssdb --empty-password
COPY mitmproxy-cetificates/mitmproxy-ca.pem /usr/local/share/ca-certificates/mitmproxy-ca.pem
RUN certutil -d $HOME/.pki/nssdb -A -t "C,," -n mitmproxy -i /usr/local/share/ca-certificates/mitmproxy-ca.pem

RUN mkdir -p /var/run/dbus

# Expose the port for VNC
EXPOSE 5900

CMD ["sh", "-c", "dbus-daemon --system --fork \
    & Xvfb :99 -screen 0 1024x768x16 & x11vnc -display :99 -forever -usepw \
    & fluxbox \
    & google-chrome --no-sandbox --disable-gpu --no-first-run --homepage file:///root/html-pages/index.html"]
