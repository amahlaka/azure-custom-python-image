#!/usr/bin/env bash

echo "Replacing strings"
TARGET=/usr/local/lib/python3.7/site-packages/celery/backends
if [ -d "$TARGET" ]; then
echo "CD into target"
cd $TARGET
else
echo "Finding celery..."
celery_root="$(dirname "$(which celery)" )"
cd $celery_root/../lib/python3.7/site-packages/celery/backends
fi
if [ -e async.py ]
then
    echo "editing usr"
    mv async.py asynchronous.py
    if [ -e redis.py ]; then
    sed -i 's/async/asynchronous/g' redis.py
    echo "REDIS"
    fi
    if [ -e rpc.py ]; then
    sed -i 's/async/asynchronous/g' rpc.py
    echo "RPC"
    fi
    echo "DONE"
fi
