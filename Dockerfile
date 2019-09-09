FROM ruby:2.6.3-alpine3.9

COPY Gemfile* /myapp/

WORKDIR /myapp
ARG BUNDLER_OPTIONS

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --update --no-cache \
      make \
      nodejs \
      yarn \
      mariadb-connector-c \
      tzdata \
      less \
      git \
      build-base \
      mariadb-dev \
      ncurses && \
    bundle install -j4 ${BUNDLER_OPTIONS}

COPY . /myapp
