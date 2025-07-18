FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    git curl build-essential python3 python3-pip cmake libcurl4-openssl-dev \
    && apt-get clean

WORKDIR /app

RUN git clone https://github.com/ggerganov/llama.cpp.git .
RUN mkdir build && cd build && cmake .. && cmake --build . --config Release

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

EXPOSE 8000

CMD ["./entrypoint.sh"]