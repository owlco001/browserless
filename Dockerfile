FROM python:3.11-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg \
    && wget -q -O /tmp/chrome.deb https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_121.0.6167.85_amd64.deb \
    && apt-get install -y --no-install-recommends /tmp/chrome.deb \
    && rm /tmp/chrome.deb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip install flask playwright && \
    playwright install chromium && \
    playwright install-deps

WORKDIR /usr/src/app
COPY app.py .
ENV PORT=7860

EXPOSE 7860
CMD ["python", "app.py"]
