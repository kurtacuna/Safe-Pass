# Python base image
FROM python:latest

# Install postgres-client, cmake, and necessary libraries for face_recognition/dlib/OpenCV
RUN apt-get update && \
    apt-get install -y \
    postgresql-client \
    cmake \
    build-essential \
    libgtk-3-dev \
    libboost-all-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    pkg-config \
    # Add libgl1-mesa-glx to resolve the libGL.so.1 error
    libgl1-mesa-glx && \
    rm -rf /var/lib/apt/lists/* # Clean up apt cache to keep image small

# Change to a directory
WORKDIR /safepass_backend

# Copy requirements.txt to workdir
COPY requirements.txt .

# Install packages
RUN pip install -r requirements.txt

# Copy the rest of the files to workdir
COPY . .

# Expose port for documentation
EXPOSE 8000