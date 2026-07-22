#!/bin/bash
echo "Starting start.sh script..."

echo "Starting MongoDB in the background..."
# Start mongod in the background, bound to localhost, with small wiredTiger cache to save memory
mongod --bind_ip 127.0.0.1 --wiredTigerCacheSizeGB 0.25 --logpath /tmp/mongodb.log &
MONGO_PID=$!

echo "MongoDB PID: $MONGO_PID"
echo "Waiting for MongoDB to be ready..."

# Wait for mongod to accept connections
# Use a simple timeout loop instead of mongosh which might not be in the path
for i in {1..15}; do
    if grep -q "Waiting for connections" /tmp/mongodb.log; then
        echo "MongoDB is ready."
        break
    fi
    echo "Waiting... ($i/15)"
    sleep 2
done

cat /tmp/mongodb.log

echo "Starting Node API..."
# Force MONGO_URI to use local DB
export MONGO_URI="mongodb://127.0.0.1:27017/ganga"
echo "MONGO_URI is set to $MONGO_URI"
npm start
