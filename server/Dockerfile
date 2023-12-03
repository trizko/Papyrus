FROM python:3.10-alpine

ENV PYTHONFAULTHANDLER=1 \
  PYTHONUNBUFFERED=1 \
  PYTHONHASHSEED=random \
  PIP_NO_CACHE_DIR=off \
  PIP_DISABLE_PIP_VERSION_CHECK=on \
  PIP_DEFAULT_TIMEOUT=100 \
  TOKENIZERS_PARALLELISM=false

RUN set -eux \
    && apk update \
    && apk add --no-cache \
        gcc \
        libc-dev \
        libffi-dev \
        python3-dev \
        openssl-dev

WORKDIR /opt/app
COPY requirements.txt /opt/app/
RUN set -eux \
    && pip install --upgrade pip \
    && pip install -r requirements.txt

COPY . /opt/app

ENTRYPOINT ["python3", "main.py"]