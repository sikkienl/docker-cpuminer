#!/bin/bash

FILE="./cpuminer"

if [ -f "$FILE" ]; then
    echo "CPU miner found. Executing it with arguments: $*"
    exec "$FILE" "$@"
else
    echo "Cpu miner not found."
    exec "$FILE" "$@"
fi