FROM ruby:3.0.0-alpine

ENV RAILS_MAX_THREADS 100
ENV RAILS_ENV production
ENV NODE_ENV production
ENV RAILS_SERVE_STATIC_FILES true
ENV RACK_TIMEOUT_SERVICE_TIMEOUT 60
ENV RAILS_LOG_TO_STDOUT true
ENV UID=8877
ENV GID=8877

RUN addgroup -g $GID -S mos 
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/mos" \
    --ingroup "mos" \
    --no-create-home \
    --uid "$UID" \
    "mos"

RUN gem install bundler:2.1.4

RUN apk add --no-cache --update build-base \
    postgresql-dev \
    tzdata \
    build-base \
    postgresql-client \
    git \
    && rm -f /var/cache/apk/*

RUN mkdir -p /mos

WORKDIR /mos

COPY . /mos

RUN chown -R mos:mos /mos

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

RUN chown mos:mos /entrypoint.sh

USER mos

WORKDIR /mos

RUN ls -lah

RUN bundle config set without 'test development' \
    && bundle install --path=vendor/bundle \
    && rm -rf vendor/bundle/ruby/3.0.0/cache/*.gem \
    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.c" -delete \
    && find vendor/bundle/ruby/3.0.0/gems/ -name "*.o" -delete

RUN rake assets:precompile

WORKDIR /mos

RUN mkdir -p tmp/pids
RUN mkdir -p tmp/cache

EXPOSE 4000
EXPOSE 4001

CMD ["/entrypoint.sh"]