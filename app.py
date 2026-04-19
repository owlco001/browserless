from flask import Flask, request, jsonify
from playwright.sync_api import sync_playwright

app = Flask(__name__)

@app.route("/", methods=["POST"])
def scrape():
    url = request.json.get("url")
    if not url:
        return jsonify({"error": "url required"}), 400
    try:
        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(url, timeout=30000)
            content = page.content()
            browser.close()
        return jsonify({"html": content})
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route("/", methods=["GET"])
def index():
    return "Browserless OK\n"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=7860)
