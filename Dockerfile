# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    gnupg \
    curl

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && sh -c 'echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
    && apt-get update && apt-get install -y \
    google-chrome-stable \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install ChromeDriver
ARG CHROMEDRIVER_VERSION=113.0.5672.63
RUN wget -O /tmp/chromedriver.zip "https://chromedriver.storage.googleapis.com/${CHROMEDRIVER_VERSION}/chromedriver_linux64.zip" \
    && unzip /tmp/chromedriver.zip -d /usr/local/bin/ \
    && rm /tmp/chromedriver.zip

# Set environment variables for webdriver_manager
ENV WDM_LOCAL 1
ENV WDM_CACHE_DIR /app/.wdm

# Install Python dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application
COPY . .

# Copy the Google service account key file
COPY hwik_key.json .

# Copy the start.sh script and give it execution permissions
COPY start.sh .
RUN chmod +x start.sh

# 권한 설정
RUN chmod -R 777 /app

# Expose port 5000
EXPOSE 5000

# Command to run the application
CMD ["./start.sh"]
