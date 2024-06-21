from flask import Flask, send_from_directory

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, Robotic World!'

@app.route('/static/<path:filename>')
def static_files(filename):
    return send_from_directory('static', filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0')
