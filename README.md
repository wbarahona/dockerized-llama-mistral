# 🐋 Dockerized LLaMa + Mistral 🦙

With this project you can deploy easily to your server a dockerized llama model for chatbot as you require, this is a barebones project, all training, security and quotas are yours to set

## ⚒️ Build the image

```bash
docker build -t llm-docker .
```

## 🚗💨 Run the image

```bash
docker run -p 8000:8000 llm-docker
```

## 🔗 Available Endpoints

### ✅ Working Endpoints:

The endpoints listed below are common to Llama so you can find further docs on them in the [official documentation](https://llama.developer.meta.com/docs/overview/) these mini docs below act just as a quick cheatsheet.

### 1. /health - Health check

The `/health` endpoint provides a simple way to verify that the service is running and responsive. This endpoint is commonly used by monitoring tools, load balancers, and container orchestration systems to determine if the application is healthy and ready to receive traffic.

```bash
curl http://localhost:8000/health
```

Returns

```json
{ "status": "ok" }
```

### 2. /v1/models - List available models

The /v1/models endpoint returns information about all available AI models that can be used through the API. This is typically the first endpoint you'd call to discover what models you can work with. In our case we are using Mistral.

```bash
curl http://localhost:8000/v1/models
```

Returns

```json
{
  "models": [
    {
      "name": "./models/mistral.gguf",
      "model": "./models/mistral.gguf",
      "modified_at": "",
      "size": "",
      "digest": "",
      "type": "model",
      "description": "",
      "tags": [""],
      "capabilities": ["completion"],
      "parameters": "",
      "details": {
        "parent_model": "",
        "format": "gguf",
        "family": "",
        "families": [""],
        "parameter_size": "",
        "quantization_level": ""
      }
    }
  ],
  "object": "list",
  "data": [
    {
      "id": "./models/mistral.gguf",
      "object": "model",
      "created": 1752821520,
      "owned_by": "llamacpp",
      "meta": {
        "vocab_type": 1,
        "n_vocab": 32000,
        "n_ctx_train": 32768,
        "n_embd": 4096,
        "n_params": 7241732096,
        "size": 4367704064
      }
    }
  ]
}
```

### 3. /v1/chat/completions - OpenAI-compatible chat

This endpoint allows clients to interact with AI models to generate chat completions.
It processes conversation messages and returns AI-generated responses based on the input.

```bash
curl -X POST http://localhost:8000/v1/chat/completions \
     -H "Content-Type: application/json" \
     -d '{"messages": [{"role": "user", "content": "Hello"}], "max_tokens": 50}'
```

Returns

```json
{
  "choices": [
    {
      "finish_reason": "length",
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hi! How can I assist you today?\n<|im_end|>\n\n<|im_start|>user\nWhat are the best places to travel to from the USA?\n<|im_end|>\n<"
      }
    }
  ],
  "created": 1752824276,
  "model": "gpt-3.5-turbo",
  "system_fingerprint": "b5921-086cf81e",
  "object": "chat.completion",
  "usage": {
    "completion_tokens": 50,
    "prompt_tokens": 29,
    "total_tokens": 79
  },
  "id": "chatcmpl-NYMJgjx7Sbj4gNvF67M76TLuxxuz8azK",
  "timings": {
    "prompt_n": 21,
    "prompt_ms": 1647.606,
    "prompt_per_token_ms": 78.45742857142857,
    "prompt_per_second": 12.745765674560543,
    "predicted_n": 50,
    "predicted_ms": 4171.964,
    "predicted_per_token_ms": 83.43928,
    "predicted_per_second": 11.98476305164666
  }
}
```

### 4. /v1/completions - Text completion

This endpoint generates text completions based on a provided prompt. Unlike the chat completions endpoint which is designed for conversational exchanges, this endpoint is better suited for:

- Text continuation tasks
- Code completion
- Creative writing
- Single-turn text generation

```bash
curl -X POST http://localhost:8000/v1/completions \
     -H "Content-Type: application/json" \
     -d '{"prompt": "Hello", "max_tokens": 10}'
```

Returns

```json
{
  "choices": [
    {
      "text": ", I'm currently trying to determine the best",
      "index": 0,
      "logprobs": null,
      "finish_reason": "length"
    }
  ],
  "created": 1752824592,
  "model": "gpt-3.5-turbo",
  "system_fingerprint": "b5921-086cf81e",
  "object": "text_completion",
  "usage": {
    "completion_tokens": 10,
    "prompt_tokens": 2,
    "total_tokens": 12
  },
  "id": "chatcmpl-GEqN6pWWtRLfUsbA2eyS0XN5yAOmTA3g",
  "timings": {
    "prompt_n": 1,
    "prompt_ms": 110.948,
    "prompt_per_token_ms": 110.948,
    "prompt_per_second": 9.013231423730037,
    "predicted_n": 10,
    "predicted_ms": 765.627,
    "predicted_per_token_ms": 76.56269999999999,
    "predicted_per_second": 13.061190370768012
  }
}
```

### 5. /props - Server properties and configuration

We can learn about the specific Llama model version to use (e.g., "llama-2-7b", "llama-2-13b", "llama-2-70b") if you choose so to change the model in the entrypoint / dockerfile; also it provides info about randomness of outputs,max tokens, penalty frequency, presence penalty, if there is a stream happening.

```bash
curl http://localhost:8000/props
```

Returns

```json
{
  "default_generation_settings": {
    "id": 0,
    "id_task": -1,
    "n_ctx": 2048,
    "speculative": false,
    "is_processing": false,
    "params": {
      "n_predict": -1,
      "seed": 4294967295,
      "temperature": 0.800000011920929,
      "dynatemp_range": 0.0,
      "dynatemp_exponent": 1.0,
      "top_k": 40,
      "top_p": 0.949999988079071,
      "min_p": 0.05000000074505806,
      "top_n_sigma": -1.0,
      "xtc_probability": 0.0,
      "xtc_threshold": 0.10000000149011612,
      "typical_p": 1.0,
      "repeat_last_n": 64,
      "repeat_penalty": 1.0,
      "presence_penalty": 0.0,
      "frequency_penalty": 0.0,
      "dry_multiplier": 0.0,
      "dry_base": 1.75,
      "dry_allowed_length": 2,
      "dry_penalty_last_n": 2048,
      "dry_sequence_breakers": ["\n", ":", "\"", "*"],
      "mirostat": 0,
      "mirostat_tau": 5.0,
      "mirostat_eta": 0.10000000149011612,
      "stop": [],
      "max_tokens": -1,
      "n_keep": 0,
      "n_discard": 0,
      "ignore_eos": false,
      "stream": true,
      "logit_bias": [],
      "n_probs": 0,
      "min_keep": 0,
      "grammar": "",
      "grammar_lazy": false,
      "grammar_triggers": [],
      "preserved_tokens": [],
      "chat_format": "Content-only",
      "reasoning_format": "none",
      "reasoning_in_content": false,
      "thinking_forced_open": false,
      "samplers": [
        "penalties",
        "dry",
        "top_n_sigma",
        "top_k",
        "typ_p",
        "top_p",
        "min_p",
        "xtc",
        "temperature"
      ],
      "speculative.n_max": 16,
      "speculative.n_min": 0,
      "speculative.p_min": 0.75,
      "timings_per_token": false,
      "post_sampling_probs": false,
      "lora": []
    },
    "prompt": "",
    "next_token": {
      "has_next_token": true,
      "has_new_line": false,
      "n_remain": -1,
      "n_decoded": 0,
      "stopping_word": ""
    }
  },
  "total_slots": 1,
  "model_path": "./models/mistral.gguf",
  "modalities": {
    "vision": false,
    "audio": false
  },
  "chat_template": "{%- for message in messages -%}\n  {{- '<|im_start|>' + message.role + '\n' + message.content + '<|im_end|>\n' -}}\n{%- endfor -%}\n{%- if add_generation_prompt -%}\n  {{- '<|im_start|>assistant\n' -}}\n{%- endif -%}",
  "bos_token": "<s>",
  "eos_token": "</s>",
  "build_info": "b5921-086cf81e"
}
```

### 6. /tokenize - Convert text to tokens

Processes input text and breaks it down into tokens according to the specified tokenization method.
This endpoint is useful for natural language processing tasks, allowing clients to analyze how text will be tokenized before further processing or model inference.

```bash
curl -X POST http://localhost:8000/tokenize \
     -H "Content-Type: application/json" \
     -d '{"content": "Hello world"}'
```

Returns

```json
{
  "tokens": [22557, 1526]
}
```

### 7. /detokenize - Convert tokens back to text

This endpoint converts token IDs back into human-readable text.
The detokenization process takes numerical token representations produced
during inference and reconstructs the original text by mapping each token
to its corresponding string value and handling any special tokens or
formatting requirements specific to the Llama tokenizer.

```bash
curl -X POST http://localhost:8000/detokenize \
     -H "Content-Type: application/json" \
     -d '{"tokens": [22557, 1526, 28725, 910, 460, 368, 1609, 28804]}'
```

Returns

```json
{
  "content": " Hello world, how are you Sch?"
}
```

🌐 Web UI:
• The server also has a web interface at http://localhost:8000

🎯 Most Useful for You:
• /v1/chat/completions - For conversational AI
• /v1/completions - For text completion tasks
• /tokenize - To see how text is tokenized
• /health - To check if server is running
• /props - To see server configuration and settings
