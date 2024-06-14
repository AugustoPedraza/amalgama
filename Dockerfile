# ./Dockerfile
# Elixir base image to start with
FROM elixir:1.17-alpine

ARG PHX_VERSION="1.7.12"
ARG MIX_ENV="dev"

# Default to UTF-8 file.encoding
ENV LANG C.UTF-8
ENV SHELL=/bin/bash
ENV MIX_ENV=${MIX_ENV}

RUN apk add --update build-base bash git postgresql-client curl inotify-tools

RUN git config --global --add safe.directory '*'

# install hex package manager
RUN mix local.hex --force && mix local.rebar --force

# install our phoenix version
RUN mix archive.install hex phx_new $PHX_VERSION --force

# install C compiler
# RUN apk add --update alpine-sdk
RUN apk add --no-cache make gcc libc-dev

# Create and change current directory.

ADD . /usr/src/app
WORKDIR /usr/src/app

# Bundle app source.
RUN MIX_ENV=$MIX_ENV mix do deps.get, deps.compile
# RUN mix deps.compile --force bcrypt_elixir
