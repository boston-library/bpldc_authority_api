# based on instructions here: https://docs.docker.com/compose/rails/
FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN gem install bundler:2.0.2
RUN mkdir /bpldc_authority_api
WORKDIR /bpldc_authority_api
COPY Gemfile /bpldc_authority_api/Gemfile
COPY Gemfile.lock /bpldc_authority_api/Gemfile.lock
RUN bundle install
COPY . /bpldc_authority_api

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
