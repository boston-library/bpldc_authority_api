FROM ruby:2.7.4

LABEL maintainer="bbarber@bpl.org, eenglish@bpl.org"

ENV LANG=C.UTF-8 \
    BUNDLER_VERSION=2.2.23

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  apt-utils \
  gnupg2 \
  curl \
  less \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
    && echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' 12 > /etc/apt/sources.list.d/pgdg.list

RUN apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
  libpq-dev \
  postgresql-client-12 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  truncate -s 0 /var/log/*log

RUN gem update --system --no-document
RUN gem install bundler:$BUNDLER_VERSION --no-document
RUN bundle config --local disable_platform_warnings true

RUN mkdir /bpldc_authority_api-app

WORKDIR /bpldc_authority_api-app

COPY Gemfile Gemfile.* /bpldc_authority_api-app/

RUN bundle config build.nokogiri --use-system-libraries
RUN bundle check || bundle install --jobs 5 --retry 5

COPY . /bpldc_authority_api-app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
