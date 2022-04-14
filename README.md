# BPLDC Authority API

[![Build Status](https://travis-ci.com/boston-library/bpldc_authority_api.svg?branch=master)](https://travis-ci.com/boston-library/bpldc_authority_api) [![Coverage Status](https://coveralls.io/repos/github/boston-library/bpldc_authority_api/badge.svg?branch=master)](https://coveralls.io/github/boston-library/bpldc_authority_api?branch=master)

A lightweight API-only Rails app that provides authority data and controlled values for descriptive metadata records conforming to the BPLDC MODS Application Profile.

See the wiki for more information:

* [Authorities List](https://github.com/boston-library/bpldc_authority_api/wiki/Authorities-list): Retrieve a list of supported authorities/vocabularies
* [Geomash API](https://github.com/boston-library/bpldc_authority_api/wiki/Geomash-API): Retrieve structured geographic information from TGN, GeoNames, and Google Maps API Geocoder
* [Controlled values](https://github.com/boston-library/bpldc_authority_api/wiki/Nomenclature-controlled-values): Returns all possible values for controlled fields: basic genre, language, license, resource type, and role
* Querying authorities
    * [Get label for vocabulary id](https://github.com/boston-library/bpldc_authority_api/wiki/Querying-authorities:-get-label-for-vocabulary-id): Use a vocabulary id to fetch the label for a term
    * [Search for terms](https://github.com/boston-library/bpldc_authority_api/wiki/Querying-authorities:-search-for-terms): Search for terms from an authority by keyword/string; returns a list of matches

## Running with Docker

Run the following commands from the project root:

1. Start Ruby/Rails and Postgres containers:
```
$ docker-compose up

```
Note entrypoint.sh runs `bundle exec rails db:prepare` which creates the databases and runs the migrations
2. From another terminal window, run:
```
$ docker-compose run app rails db:seed
```
3. To rebuild the container run
```
$ docker-compose build --no-cache
```
The application will be available on `localhost:3001`. Use `docker-compose up -d` and `docker-compose down` to start/stop the application.

## Add a line for testing whether pull-request job works in Jenkins