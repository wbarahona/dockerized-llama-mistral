FROM python:3.11-slim

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential cmake curl git libcurl4-openssl-dev \
    pkg-config libopenblas-dev liblapack-dev \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Set workdir
WORKDIR /app

# Set environment variables for ARM64 compilation
ENV CMAKE_ARGS="-DGGML_BLAS=ON -DGGML_BLAS_VENDOR=OpenBLAS -DGGML_NATIVE=OFF"
ENV FORCE_CMAKE=1

# Install llama-cpp-python with server support
RUN pip install --upgrade pip setuptools wheel
RUN pip install llama-cpp-python[server]

# Copy entrypoint
COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

# Expose the OpenAI-compatible chat API port
EXPOSE 8000

# Start using entrypoint
CMD ["./entrypoint.sh"]
