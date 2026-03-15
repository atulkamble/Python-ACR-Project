from flask import Flask, jsonify, render_template
from datetime import datetime

app = Flask(__name__)

@app.route('/')
def home():
    return render_template('index.html', 
                         current_time=datetime.now().strftime('%Y-%m-%d %H:%M:%S'))

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'}), 200

@app.route('/api')
def api():
    return jsonify({
        'message': 'Hello, World!',
        'status': 'running',
        'timestamp': datetime.now().isoformat()
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
