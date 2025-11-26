# docker build -t abhisheg/alpine/mcp-streamablehttp-proxy --target alpine-release .
# docker build -t abhisheg/nodejs/mcp-streamablehttp-proxy --target node-release .

FROM python:3.12 AS builder

# Set working directory
WORKDIR /app

RUN pip install build twine
# Copy the package files
ADD . /app
# Build the package
RUN python -m build

FROM node:22.12-alpine AS node-release
LABEL authors="abhisheg"

# Set working directory
WORKDIR /app

# install python and pip
RUN apk add --no-cache python3 py3-pip curl
# Install the mcp-streamablehttp-proxy package
COPY --from=builder /app/dist/ /app/python/dist/
RUN pip install /app/python/dist/*.whl --break-system-packages

FROM alpine:3.20 AS alpine-release
LABEL authors="abhisheg"

# Set working directory
WORKDIR /app

# install python and pip
RUN apk add --no-cache python3 py3-pip curl
# Install the mcp-streamablehttp-proxy package
COPY --from=builder /app/dist/ /app/python/dist/
RUN pip install /app/python/dist/*.whl --break-system-packages
