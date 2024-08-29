FROM ruby:3.1.6

LABEL maintainer="bbarber@bpl.org, eenglish@bpl.org"

ENV LANG=C.UTF-8 \
    BUNDLER_VERSION=2.5.9

RUN apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq --no-install-recommends apt-utils

RUN apt-get update -qq \
  && DEBIAN_FRONTEND=noninteractive apt-get install -qq --no-install-recommends build-essential \
  libxml2-dev \
  libxslt1-dev \
  gnupg2 \
  curl \
  less \
  && apt-get clean \
  && rm -rf /var/cache/apt/archives/* \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
  && truncate -s 0 /var/log/*log

RUN apt-get update -qq \
  && apt-get install -y build-essential apt-utils postgresql-client libpq-dev

RUN gem update --system --no-document --quiet --silent
RUN gem install bundler:$BUNDLER_VERSION --no-document --quiet --silent
RUN bundle config --local disable_platform_warnings true
RUN bundle config build.nokogiri --use-system-libraries

RUN mkdir /bpldc_authority_api-app

WORKDIR /bpldc_authority_api-app

COPY Gemfile Gemfile.* /bpldc_authority_api-app/

RUN bundle check || bundle install --jobs 5 --retry 5

COPY . /bpldc_authority_api-app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

# Start the main process.
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
