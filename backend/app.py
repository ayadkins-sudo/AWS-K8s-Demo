from flask import Flask, jsonify
import os
import socket

app = Flask(__name__)

@app.get("/api/health")
def health():
    return jsonify({"status": "ok"})

@app.get("/api/info")
def info():
    return jsonify({
        "message": "AWS + Kubernetes demo is running",
        "hostname": socket.gethostname(),
        "environment": os.getenv("APP_ENV", "dev")
    })

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)