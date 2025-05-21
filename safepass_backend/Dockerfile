# Python base image
FROM python:latest

# Install postgres-client
RUN apt-get update && apt-get install -y postgresql-client

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