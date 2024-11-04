# Use the official Ubuntu 20.04 base image
FROM ubuntu:20.04

# Set the environment variable to avoid interactive prompts during package installations
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    x11vnc \
    xvfb \
    novnc \
    websockify \
    xterm \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set a password for VNC access (change 'yourpassword' to a secure password)
RUN mkdir -p /etc/x11vnc && \
    echo "vcmp" | x11vnc -storepasswd - /etc/x11vnc/passwd

# Expose the ports for NoVNC and VNC
EXPOSE 80 5900

# Start the VNC server and NoVNC
CMD ["sh", "-c", "xvfb-run -n 1 -s '-screen 0 1024x768x24' xterm & x11vnc -display :1 -usepw -forever -passwdfile /etc/x11vnc/passwd & websockify --web /usr/share/novnc 80 localhost:5900"]
