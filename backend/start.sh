#!/bin/bash
set -e

echo "Starting MongoDB in the background..."
# Start mongod in the background, bound to localhost, with small wiredTiger cache to save memory
mongod --bind_ip 127.0.0.1 --wiredTigerCacheSizeGB 0.25 --logpath /var/log/mongodb.log --fork

echo "Waiting for MongoDB to be ready..."
# Wait for mongod to accept connections
until mongosh --eval "print(\"waited for connection\")"
do
    echo "Waiting for MongoDB..."
    sleep 2
done

echo "MongoDB is ready. Starting Node API..."
# Start the Node.js API. We override the MONGO_URI from the environment.
export MONGO_URI="mongodb://127.0.0.1:27017/ganga"
npm start
