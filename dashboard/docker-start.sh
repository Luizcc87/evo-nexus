#!/bin/bash
# EvoNexus Docker Startup Script
# Starts both the Flask backend and the Node.js terminal-server.

# Start terminal-server in the background
echo "Starting terminal-server on port 32352..."
/usr/bin/node /workspace/dashboard/terminal-server/bin/server.js 2>&1 &

# Start scheduler in the background
echo "Starting scheduler..."
/root/.local/bin/uv run python /workspace/scheduler.py 2>&1 &

# Start Flask dashboard in the foreground
echo "Starting dashboard on port ${EVONEXUS_PORT:-8080}..."
cd /workspace/dashboard/backend
/root/.local/bin/uv run python app.py 2>&1
