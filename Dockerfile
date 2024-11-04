# Use a lightweight Ubuntu image
FROM ubuntu:20.04

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive
ENV USER=root
ENV PASSWORD=password
ENV NGROK_AUTH_TOKEN=your_ngrok_auth_token

# Update and install dependencies
RUN apt-get update && \
    apt-get install -y \
    xfce4 xfce4-terminal \
    tightvncserver \
    dbus-x11 \
    x11-xserver-utils \
    wget \
    supervisor \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install ngrok
RUN wget https://bin.equinox.io/c/bNyj1mQVY4c/ngrok-stable-linux-amd64.zip && \
    unzip ngrok-stable-linux-amd64.zip && \
    mv ngrok /usr/local/bin/ngrok && \
    rm ngrok-stable-linux-amd64.zip

# Set up VNC server
RUN mkdir -p ~/.vnc && \
    echo "$PASSWORD" | vncpasswd -f > ~/.vnc/passwd && \
    chmod 600 ~/.vnc/passwd && \
    echo "startxfce4 &" > ~/.vnc/xstartup && \
    chmod +x ~/.vnc/xstartup

# Expose VNC port
EXPOSE 5901

# Add Supervisor configuration to keep VNC and ngrok running
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Run Supervisor to manage services
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
