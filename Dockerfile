FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && \
    apt-get install -y novnc websockify && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Expose the port on which NoVNC runs (80 inside the container)
EXPOSE 80

# Command to run NoVNC
CMD ["websockify", "--web", "/usr/share/novnc", "80", "localhost:5901"]
