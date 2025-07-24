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
    return jsonify(result=1 + 2)  # пример функции

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
