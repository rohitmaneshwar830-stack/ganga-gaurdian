FROM mongo:6.0

# Install Node.js
RUN apt-get update && apt-get install -y curl gnupg && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean

# Create app directory
WORKDIR /usr/src/app

# Copy package info
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application
COPY . .

# Copy the startup script and make it executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 5000 (MongoDB port 27017 is local only)
EXPOSE 5000

# Run startup script
CMD ["/start.sh"]
