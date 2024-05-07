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


<!-- ## Pipeline script for bpldc_authority_jenkinsfile
pipeline {
    agent any

    stages {
        stage('CheckoutCode') {
            steps {
                
                checkout([$class: 'GitSCM', 
                    branches: [[name: '*/${BRANCH_NAME}']], 
                    userRemoteConfigs: [[
                        url: "https://github.com/boston-library/bpldc_authority_api.git",
                        credentialsId: 'bplwebmaster'
                        ]]
                ])
            }
        }

        stage('Preparation') {
            steps {
                sh '''
                    #!/usr/bin/env bash
                    set -xe
                    
                    if [ "$(docker ps -qa -f name=bpldc_authority_api)" ]; then 
                        docker stop $(docker ps -qa -f name=bpldc_authority_api) || true
                    fi
                    
                    if [ "$(docker ps -qa -f name=bpldc_authority_cache)" ]; then 
                        docker stop $(docker ps -qa -f name=bpldc_authority_cache) || true
                    fi
                    
                    if [ "$(docker ps -qa -f name=bpldc_authority_pg)" ]; then 
                        docker stop $(docker ps -qa -f name=bpldc_authority_pg) || true
                    fi
                    
                    if [ "$(docker ps -qa -f name=bpldc_authority_api)" ]; then 
                        docker rm $(docker ps -qa -f name=bpldc_authority_api) || true
                    fi
                    
                    if [ "$(docker ps -qa -f name=bpldc_authority_cache)" ]; then 
                        docker rm $(docker ps -qa -f name=bpldc_authority_api) || true
                    fi
                    
                    if [ "$(docker ps -qa -f name=bpldc_authority_pg)" ]; then 
                        docker rm $(docker ps -qa -f name=bpldc_authority_pg) || true
                    fi                
                '''
            }
        }
        
        stage('Docker images build') {
            steps {
                sh '''
                #!/usr/bin/env bash
                
                set -xe
                
                echo "GEONAMES_USERNAME=boston_library" > .env
                echo "GOOGLE_MAPS_API_KEY=${GOOGLE_MAPS_API_KEY}" >> .env
                echo "BPLDC_REDIS_CACHE_URL=" >> .env
                
                cat .env
                
                sudo docker compose build 
                sudo docker compose up -d
                '''
            }    
        }
        
        stage('Test') {
            steps {
                sh '''
                    #!/usr/bin/env bash
                    set -xe
                    sudo docker-compose run app bundle exec rake --verbose
                '''
            }
        }
    }
    
    post {
        always {
            sh '''
                #!/usr/bin/env bash
                set -xe
                sudo docker stop $(docker ps -aq)
                sudo docker rm $(docker ps -aq)
                
                sudo docker rmi bostonlibrary/bpldc_authority_api:dev-latest
            '''
        }
    }
}

 -->