from flask import Flask, jsonify

app = Flask(__name__)

@app.route('/')
def hello():
    return 'Hello, World!'

@app.route('/health')
def health():
    return jsonify(status='OK')

@app.route('/add')
def add():
    return jsonify(result=1 + 2)
