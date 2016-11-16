FROM ubuntu:latest

MAINTAINER Youcef Rahal

RUN apt-get update --fix-missing

# Fetch and install Anaconda3 and dependencies
RUN apt-get install -y wget bzip2 && \
    wget https://repo.continuum.io/archive/Anaconda3-4.2.0-Linux-x86_64.sh -O ~/anaconda.sh && \
    /bin/bash ~/anaconda.sh -b -p /opt/anaconda3 && \
    rm ~/anaconda.sh
# Add Anaconda3 to the PATH
ENV PATH /opt/anaconda3/bin:$PATH

# Update pip
RUN pip install --upgrade pip

# Install opencv and moviepy (pillow is already installed)
RUN conda install -y -c https://conda.anaconda.org/menpo opencv3 && \
    pip install moviepy

# Install firefox (for jupyter)
RUN apt-get install -y firefox

# Install x11vnc and dependencies and set a simple password
RUN apt-get install -y x11vnc xvfb && \
    mkdir ~/.vnc && \
    x11vnc -storepasswd 1234 ~/.vnc/passwd

# Install icewm (window manager)
RUN apt-get install -y icewm
# Auto start icewm in the ~/.bashrc (if it's not running)
RUN bash -c 'echo "if ! pidof -x \"icewm\" > /dev/null; then nohup icewm &>> /var/log/icewm.log & fi" >> /root/.bashrc'

# Install extras to be able read media files
RUN apt-get install -y software-properties-common
RUN add-apt-repository multiverse
RUN apt-get update
RUN apt-get install -y gstreamer1.0-libav

# Set the working directory
WORKDIR /src

# The port where x11vnc will be running
EXPOSE 5900

# Run x11vnc on start
CMD x11vnc -create -forever -usepw