# Use the base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    novnc \
    websockify \
    x11vnc \
    supervisor \
    && apt-get clean

# Set the environment variable for screen resolution
ENV RESOLUTION 1707x1067
ENV VNC_PASSWORD=mysecretpassword

# Create a VNC password
RUN mkdir -p ~/.vnc && \
    x11vnc -storepasswd $VNC_PASSWORD ~/.vnc/passwd

# Expose the ports for NoVNC and VNC
EXPOSE 80 5900

# Create a supervisord configuration file
RUN echo "[supervisord]" > /etc/supervisor/supervisord.conf && \
    echo "nodaemon=true" >> /etc/supervisor/supervisord.conf && \
    echo "[program:novnc]" >> /etc/supervisor/supervisord.conf && \
    echo "command=websockify --web /usr/share/novnc/ 80 localhost:5900" >> /etc/supervisor/supervisord.conf && \
    echo "[program:vnc]" >> /etc/supervisor/supervisord.conf && \
    echo "command=x11vnc -display :0 -usepw -forever -create" >> /etc/supervisor/supervisord.conf

# Start supervisord
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]
