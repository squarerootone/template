FROM python:3.13-slim

# Set Python3 as the default python version
RUN ln -s /usr/local/bin/python3 /usr/bin/python

# Install additional dependencies
RUN apt-get update && apt-get install -y git jq
    # curl wget unzip

RUN python -m pip install uv && \
    uv pip install --system ruff>=0.6.9 pre-commit>=4.0.1 keyring keyrings.google-artifactregistry-auth
    