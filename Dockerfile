FROM ruby:2.6.6

LABEL maintainer="bbarber@bpl.org, eenglish@bpl.org"

ENV BUNDLER_VERSION=2.1.2

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

RUN gem update --system
RUN gem install bundler:2.1.2

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
