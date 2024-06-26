#!/bin/bash

# Find the PID of the Python process running the specific app.py
PID=$(pgrep -f "python3 /home/ubuntu/pythonApp/app.py")

if [ -z "$PID" ]; then
    echo "No running Python Flask application found."
else
    # Terminate the Python process
    echo "Stopping Python Flask application with PID: $PID"
    kill $PID
    echo "Application stopped."
fi
