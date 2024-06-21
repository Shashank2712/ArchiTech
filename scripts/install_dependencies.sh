#!/bin/bash

cd /home/ubuntu/pythonApp
source venv/bin/activate

pip3 install flask

# Find the PID of the Python process running the specific app.py
PID=$(pgrep -f "python3 /home/ubuntu/pythonApp/app.py")

if [ -z "$PID" ]; then
    echo "No running Python Flask application found."
else
    # Terminate the Python process
    echo "Stopping Python Flask application with PID: $PID"
    sudo kill $PID
    echo "Application stopped."
fi

#!/bin/bash
cd /home/ubuntu/pythonApp
nohup python3 /home/ubuntu/pythonApp/app.py > /home/ubuntu/pythonApp/nohup.out 2>&1 &
