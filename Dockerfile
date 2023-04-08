# Use an official Python runtime as a parent image
FROM python:3.8-slim-buster

# Set the working directory to /XM_exercise
WORKDIR /XM_exercise

# Copy the entire directory into the container
COPY . /XM_exercise

RUN python3 -m pip install flask
# Install robot framework
RUN python3 -m pip install robotframework

RUN python3 -m pip install robotframework-requests

# Expose the logs directory
VOLUME ["monitor_logs"]

VOLUME ["functional_logs"]

VOLUME ["performance_logs"]
