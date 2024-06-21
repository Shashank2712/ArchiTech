from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return "Hello, Shashank's World!. This is Chithi Robot. Speed 1 THz, Memory 1 ZB"

if __name__ == '__main__':
    app.run(host='0.0.0.0')
