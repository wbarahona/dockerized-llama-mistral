#!/bin/bash

MODEL_DIR="./models"
MODEL_PATH="$MODEL_DIR/mistral.gguf"
MODEL_URL="https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/mistral-7b-instruct-v0.1.Q4_K_M.gguf"

# Download model if not present
if [ ! -f "$MODEL_PATH" ]; then
  echo "🧠 Downloading Mistral model..."
  mkdir -p "$MODEL_DIR"
  curl -L -o "$MODEL_PATH" "$MODEL_URL"
fi

# Find the server executable
echo "🔍 Looking for server executable..."
SERVER_EXEC=$(find ./build -name "llama-server" -type f -executable | head -n 1)

if [ -z "$SERVER_EXEC" ]; then
  echo "❌ Error: Could not find the server executable"
  # List what's in build directory for debugging
  find ./build -type f -executable
  exit 1
fi

echo "✅ Found server at: $SERVER_EXEC"

# Start llama.cpp in server mode with chat enabled
echo "🚀 Starting LLM server with chat support..."
"$SERVER_EXEC" -m "$MODEL_PATH" \
  --ctx-size 2048 \
  --threads 4 \
  --port 8000 \
  --host 0.0.0.0
