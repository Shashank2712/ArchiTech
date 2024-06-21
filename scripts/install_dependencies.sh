#!/bin/bash

LOG_FILE="/var/log/deploy.log"
exec > >(tee -a $LOG_FILE) 2>&1

APP_DIR="/home/ubuntu/pythonApp"
APP_SCRIPT="app.py"
VENV_DIR="$APP_DIR/venv"
NOHUP_OUT="$APP_DIR/nohup.out"
APP_OUTPUT_FILE="$APP_DIR/file_from_app"

echo "Starting deployment script"

# Update package list and install necessary packages
echo "Updating package list..."
sudo apt-get update -y

echo "Installing required packages..."
sudo apt-get install -y python3-pip awscli

# Navigate to the application directory
cd $APP_DIR || { echo "Failed to change directory to ${APP_DIR}"; exit 1; }

# Set up and activate the virtual environment
if [ ! -d "$VENV_DIR" ]; then
    echo "Setting up virtual environment"
    python3 -m venv $VENV_DIR
fi
echo "Activating virtual environment"
source $VENV_DIR/bin/activate

# Install Flask and other Python dependencies
echo "Installing Python dependencies..."
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

# Wait for the application to start (adjust sleep time as needed)
sleep 5

# Capture the output of the application and save it to file_from_app
echo "Capturing output from app.py and saving to file_from_app"
sudo cat $NOHUP_OUT > $APP_OUTPUT_FILE

# Upload file_from_app to S3 bucket
S3_BUCKET="devops-assignment-shashank"
echo "Uploading file_from_app to S3 bucket ${S3_BUCKET}"
aws s3 cp $APP_OUTPUT_FILE s3://$S3_BUCKET/file_from_app

echo "Deployment script completed"
