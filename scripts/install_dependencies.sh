#!/bin/bash

LOG_FILE="/var/log/deploy.log"
sudo exec > >(tee -a $LOG_FILE) 2>&1

APP_DIR="/home/ubuntu/pythonApp"
APP_SCRIPT="app.py"
VENV_DIR="$APP_DIR/venv"
NOHUP_OUT="$APP_DIR/nohup.out"

echo "Starting deployment script"

# Navigate to the application directory
cd $APP_DIR || { echo "Failed to change directory to ${APP_DIR}"; exit 1; }

# Set up and activate the virtual environment
if [ ! -d "$VENV_DIR" ]; then
    echo "Setting up virtual environment"
    python3 -m venv $VENV_DIR
fi
echo "Activating virtual environment"
source $VENV_DIR/bin/activate

# Install Flask
echo "Installing Flask"
pip3 install flask

# Find the PID of the Python process running the specific app.py
PID=$(pgrep -f "python3 $APP_DIR/$APP_SCRIPT")

if [ -z "$PID" ]; then
    echo "No running Python Flask application found."
else
    # Terminate the Python process
    echo "Stopping Python Flask application with PID: $PID"
    sudo kill $PID
    echo "Application stopped."
fi

# Start the Flask application using nohup
echo "Starting Python Flask application"
nohup python3 $APP_DIR/$APP_SCRIPT > $NOHUP_OUT 2>&1 &

echo "Deployment script completed"
