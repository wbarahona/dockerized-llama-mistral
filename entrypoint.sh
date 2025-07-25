#!/bin/bash
set -e  # Exit on any error

MODEL_DIR="./models"
MODEL_FILE="mistral-7b-instruct-v0.1.Q4_K_M.gguf"
MODEL_PATH="$MODEL_DIR/$MODEL_FILE"
MODEL_URL="https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.1-GGUF/resolve/main/$MODEL_FILE"

# Create models directory
mkdir -p "$MODEL_DIR"

# Download model if not present
if [ ! -f "$MODEL_PATH" ]; then
  echo "🧠 Downloading Mistral model (~4GB)..."
  echo "This may take several minutes depending on your internet connection."
  
  # Download with progress bar and resume capability
  curl -L --progress-bar --retry 3 --retry-delay 5 -C - -o "$MODEL_PATH" "$MODEL_URL"
  
  # Verify download
  if [ ! -f "$MODEL_PATH" ] || [ ! -s "$MODEL_PATH" ]; then
    echo "❌ Model download failed!"
    exit 1
  fi
  
  echo "✅ Model downloaded successfully!"
else
  echo "📦 Model already exists, skipping download."
fi

echo "🚀 Starting llama-cpp-python OpenAI-compatible server..."
echo "Server will be available at http://localhost:8000"
echo "OpenAI API endpoint: http://localhost:8000/v1"

# Start the server with error handling
python3 -m llama_cpp.server \
  --model "$MODEL_PATH" \
  --chat_format chatml \
  --n_ctx 4096 \
  --n_threads 4 \
  --host 0.0.0.0 \
  --port 8000
