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

<!-- 
#!groovy
@Library("bpllib2@jenkinsfile-shared-library") _

def bpl_tool = new org.bpl.bpl_tools()

pipeline {
    agent any
       
    environment {
        RAILS_ENV = 'test'
        // RAILS_ENV = 'staging'
    } 
    
    stages {
   
        // stage('CheckoutCode') {
        //     steps {
        //         checkout([$class: 'GitSCM', 
        //             branches: [[name: '*/${BRANCH_NAME}']], 
        //             userRemoteConfigs: [[
        //                 url: "https://github.com/boston-library/Commonwealth_3.git",
        //                 credentialsId: 'bplwebmaster'
        //                 ]]
        //         ])
        //     }
        // }

        stage('CheckoutCode') {
            steps {
                script {  
                    echo "bpl_tool is ${bpl_tool}"
                    echo "In Jenkinsfile phase: Checkout Source Code" 
                    bpl_tool.CheckoutCode() 
                }
            }
        }
        
        stage('Preparation') {
            steps {
                script {  
                    echo "In Jenkinsfile phase: Preparation at the very begining"                   
                    bpl_tool.RunPreparation()
                }                
            }
        }

        // stage ('Install new ruby'){
        //     steps {
        //         sh '''
        //             #!/bin/bash -l
        //             set +x
   
        //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        //                 source /var/lib/jenkins/.rvm/bin/rvm
        //             else 
        //                 exit
        //             fi
                    
        //             EXPECTED_RUBY=`cat .ruby-version`
        //                         ## /var/lib/jenkins/.rvm/bin/rvm list
        //             echo "EXPECTED_RUBY is $EXPECTED_RUBY"
        //             set -x
        //             rvm list
        //             rvm use ${EXPECTED_RUBY} --default
        //             ruby --version
                    
        //         '''
        //     }
        // }

        stage ('Install new ruby'){
            steps {
                script {  
                    echo "In Jenkins phase: Install new ruby" 
                    def EXPECTED_RUBY = sh(returnStdout: true, script: 'cat .ruby-version')
                    echo "EXPECTED_RUBY is $EXPECTED_RUBY"                    
                    bpl_tool.InstallNewRuby(EXPECTED_RUBY) 
                }
            }
        }
        
        // stage('bundle install') {
        //     steps {
        //         sh '''
        //             #!/bin/bash --login
        //             set +x
                    
        //             EXPECTED_RUBY=`cat .ruby-version`
    
        //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        //                 source /var/lib/jenkins/.rvm/bin/rvm
        //             else 
        //                 exit
        //             fi    
                    
        //             rvm use ${EXPECTED_RUBY} --default
                    
        //             bundle install --jobs=3 --retry=3
                    
        //         '''
        //     }
        // }

        stage ('Bundle Install .. '){
            steps {
                script {  
                    echo "In Jenkins phase: bundle install "                    
                    bpl_tool.RunBundleInstall() 
                }
            }
        }

        stage ('DB preparation'){
            steps {
                script {  
                    echo "In Jenkins phase: DB preparation " 
                    railsEnv = env.RAILS_ENV
                            // sh "printenv"
                    echo "railsEnv variables is : ${railsEnv}"                   
                    bpl_tool.RunDBpreparation(railsEnv) 
                }
            }
        }

        // stage('DB preparation') {
        //     steps {
        //         sh '''
        //             #!/bin/bash --login
        //             set +x
                    
        //             ls -alt
        //             EXPECTED_RUBY=`cat .ruby-version`
                
        //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        //                 source /var/lib/jenkins/.rvm/bin/rvm
        //             else 
        //                 exit
        //             fi    
                    
        //             rvm use ${EXPECTED_RUBY} --default
        //             set -x
                    
        //             RAILS_ENV=staging bundle exec rails db:prepare
        //             RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
                    
        //         '''
        //     }
        // }

        stage('CI') {
            steps {
                script {  
                    echo "In Jenkins phase: running CI testing "                   
                    bpl_tool.RunCI() 
                }
            }
        }

        stage('Deploy') {
            steps {
                script {  
                    echo "In Jenkins phase: Capistrano deploying "
                    railsEnv = env.RAILS_ENV
                    echo "railsEnv is ${railsEnv}"              
                    bpl_tool.RunDeployment(railsEnv) 
                }
            }
        }
        
        // stage('Deploy') {
        //     steps {
        //         script {
        //             sh """
        //                 #!/bin/bash --login
        //                 set -x
                        
        //                 # STAGE_NAME=\$stage_name_password
        //                 # SERVER_IP=\$server_ip_password
        //                 # DEPLOY_USER=\$deploy_user_password
        //                 # SSH_KEY=\$ssh_key_password

        //                 # GIT_HTTP_USERNAME=\$GIT_HTTP_USERNAME_password
        //                 # GIT_HTTP_PASSWORD=\$GIT_HTTP_PASSWORD_password
    

        //                 EXPECTED_RUBY=`cat .ruby-version`
        //                 echo "EXPECTED_RUBY is \$EXPECTED_RUBY"
                            
        //                 set +x
                        
        //                 if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        //                     source /var/lib/jenkins/.rvm/bin/rvm
        //                 else 
        //                     exit
        //                 fi    
                        

        //                 rvm list
        //                 rvm install "\$EXPECTED_RUBY"
        //                 rvm use "\$EXPECTED_RUBY" --default
        //                 whereis ruby
        //                 ruby --version

        //                 RAILS_ENV=staging cap staging install --trace
        //                 RAILS_ENV=staging cap -T
                        
                        
        //                 ## If using GIT_HTTP_USERNAME/PASSWORD from Jenkins level, 
        //                 ## Capistrano breaks here!
        //                 RAILS_ENV=staging cap staging deploy:check
        //                 RAILS_ENV=staging cap staging deploy --dry-run --trace
        //                 RAILS_ENV=staging cap staging deploy --trace
                        
        //                 if [[ -f ./config/deploy/production.rb ]]; then 
        //                     echo "There is ./config/deploy/production.rb created!"
        //                     ls -alt ./config/deploy/production.rb
        //                 else 
        //                     echo "There is NO ./config/deploy/production.rb yet"
        //                 fi   
        //             """
        //         }            
        //     }
        // }
    }
}    

==============
Another workable jenkinsfile


#!groovy
@Library("bpldc_lib@jenkinsfile") _

def bpl_tool = new org.bpl.bpl_tools()

pipeline {
    agent any

    environment {
        RAILS_ENV = 'test'
        // RAILS_ENV = 'staging'
    } 

    options {
        ansiColor('xterm')
    }
    
    stages {
   
                // stage('CheckoutCode') {
                //     steps {
                //         checkout([$class: 'GitSCM', 
                //             branches: [[name: '*/${BRANCH_NAME}']], 
                //             userRemoteConfigs: [[
                //                 url: "https://github.com/boston-library/Commonwealth_3.git",
                //                 credentialsId: 'bplwebmaster'
                //                 ]]
                //         ])
                //     }
                // }

        stage('CheckoutCode') {
            steps {
                script {  
                    echo "bpl_tool is ${bpl_tool}"
                    echo "In Jenkinsfile phase: Checkout Source Code" 
                    bpl_tool.CheckoutCode() 
                }
            }
        }
        
        stage('Preparation') {
            steps {
                script {  
                    echo "In Jenkinsfile phase: Preparation at the very begining"                   
                    bpl_tool.RunPreparation()
                }                
            }
        }

        stage ('Install new ruby'){
            steps {
                script {  
                    echo "In Jenkins phase: Install new ruby" 
                    // def EXPECTED_RUBY = sh(returnStdout: true, script: 'cat .ruby-version')
                    EXPECTED_RUBY = '3.2.5'
                    echo "EXPECTED_RUBY is $EXPECTED_RUBY"                    
                    bpl_tool.InstallNewRuby(EXPECTED_RUBY) 
                }
            }
        }

        stage ('Bundle Install .. '){
            steps {
                script {  
                    echo "In Jenkins phase: bundle install "                    
                    bpl_tool.RunBundleInstall() 
                }
            }
        }

        stage ('DB preparation'){
            steps {
                script {  
                    echo "In Jenkins phase: DB preparation " 
                    railsEnv = env.RAILS_ENV
                            // sh "printenv"
                    echo "railsEnv variables is : ${railsEnv}"                   
                    bpl_tool.RunDBpreparation(railsEnv) 
                }
            }
        }

        stage('CI') {
            steps {
                script {  
                    echo "In Jenkins phase: running CI testing "                   
                    bpl_tool.RunCI() 
                }
            }
        }

        stage('Deploy') {
            steps {
                script {  
                    echo "In Jenkins phase: Capistrano deploying "
                    railsEnv = env.RAILS_ENV
                    server_ip = env.SERVER_IP
                    ssh_key = env.SSH_KEY
                            // echo "railsEnv is ${railsEnv}, server_ip is ${server_ip}, ssh_key is ${ssh_key}"              
                    bpl_tool.RunDeployment(railsEnv, server_ip, ssh_key) 
                }
            }
        }
    }

    post {
        failure {
            emailext (
                subject: "Build failed in Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Build failed in Jenkins:</p>
                        <p>Job: ${env.JOB_NAME}</p>
                        <p>Build Number: ${env.BUILD_NUMBER}</p>
                        <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }

}    
================



And its shared library:
=================
#!groovy
package org.bpl

def CheckoutCode(){
  checkout([$class: 'GitSCM', 
      branches: [[name: '*/${BRANCH_NAME}']], 
      userRemoteConfigs: [[
          url: "https://github.com/boston-library/bpldc_authority_api.git",
          credentialsId: 'bplwebmaster'
          ]]
  ])
}

def GetCode(srcType,branchName,gitHttpURL,credentialsId){
    if (srcType == "git"){
        println("Downloading code from branch: ${branchName}")
        checkout([
            $class: 'GitSCM', branches: [[name: "${branchName}"]], 
            extensions: [],
            userRemoteConfigs: [[credentialsId: "{$credentialsId}", url: "${gitHttpURL}"]]
            ])
    }
}

def InstallNewRuby(rubyVersion){
   println("Installing new ruby version by being called: ${rubyVersion}")
   withEnv(["RUBYVERSION=${rubyVersion}"]){
      sh '''
      #!/bin/bash --login
 
      ## EXPECTED_RUBY=`cat .ruby-version`
      echo "ruby_version is ${RUBYVERSION}"

      source /var/lib/jenkins/.bashrc
      source /var/lib/jenkins/.bash_profile
      source /var/lib/jenkins/.profile

      if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        source /var/lib/jenkins/.rvm/bin/rvm
      else 
        exit
      fi

      echo "after sourcing rvm..."
      rvm install ${RUBYVERSION}
      ## /var/lib/jenkins/.rvm/bin/rvm get stable
      rvm use ${RUBYVERSION} --default
      rvm alias create --default  ${RUBYVERSION} 
      rvm alias create --current  ${RUBYVERSION} 

      # # bundle install
      whereis ruby
      ruby --version                    
           
      '''.stripIndent()
   }
}

def RunPreparation(){
  println("RUN bundle install ")
  sh '''
    #!/bin/bash --login

    sudo sed -i 's/port = 5433/port = 5432/' /etc/postgresql/15/main/postgresql.conf
    #sudo cp /etc/postgresql/{9.3,12}/main/pg_hba.conf
    sudo pg_ctlcluster 15 main restart
    
    export RAILS_ENV=test
    
    export PGVER=12
    export PGHOST=127.0.0.1
    export PGUSER=postgres
    export PGPASSWORD=postgres
    export PGPORT=5432
    export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
    export RAILS_VERSION=6.0.5

    EXPECTED_RUBY=`cat .ruby-version`
    BUNDLE_VER=$(tail -1 ./Gemfile.lock | xargs)

    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        source /var/lib/jenkins/.rvm/bin/rvm
    else 
        exit
    fi

    set -e

    rvm install ${EXPECTED_RUBY} -C --with-jemalloc
    ## /var/lib/jenkins/.rvm/bin/rvm get stable
    rvm use ${EXPECTED_RUBY} --default 
    rvm alias create --default  ${EXPECTED_RUBY} 
    rvm alias create --current  ${EXPECTED_RUBY} 

    ruby --version


    echo "and bundle version is ${BUNDLE_VER}"
    export BUNDLE_GEMFILE=$PWD/Gemfile                
    # gem update --system --no-document
    gem update --system 
    gem install bundler:${BUNDLE_VER} --no-document
    
    ## Because previous capistrano deployment creates a new production.rb that
    ## cannot pass the CI tests. Remove it if we are in test/staging environment
    ## If in production environment, it should be passed by CI.
    if [[ -f ./config/deploy/production.rb ]]; then 
        ls -alt ./config/deploy/production.rb
        git clean -f config/deploy/production.rb
    else 
        echo "There is NO ./config/deploy/production.rb yet"
    fi 
  '''
}

def RunBundleInstall(){
  println("RUN bundle install ")
  sh '''
    #!/bin/bash -l
   
    echo "In  shared library,  bundle install" 
    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
       source /var/lib/jenkins/.rvm/bin/rvm
    else 
       exit
    fi    
    
    ## rvm use ${EXPECTED_RUBY} --default
    bundle install

  '''
}

def RunDBpreparation(railsEnv){
  println("RUN DB prepare and migrate ")
  withEnv(["RAILS_ENV=${railsEnv}"]){
    sh '''
      #!/bin/bash -l
     
      echo "RAILS_ENV from Jenkinsfile is ${RAILS_ENV}"
      echo "In  shared library,  db:prepare and db:migrate " 
      if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
         source /var/lib/jenkins/.rvm/bin/rvm
      else 
         exit
      fi    

      EXPECTED_RUBY=`cat .ruby-version`

      rvm install ${EXPECTED_RUBY}
         ## /var/lib/jenkins/.rvm/bin/rvm get stable
      rvm use ${EXPECTED_RUBY} --default
      rvm alias create --default  ${EXPECTED_RUBY} 
      rvm alias create --current  ${EXPECTED_RUBY} 
      
      # RAILS_ENV=${RAILS_ENV} bundle exec rails db:prepare
      # RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate

      bundle exec rails db:prepare
      bundle exec rails db:migrate

    '''
  }
}


def RunCI(){
  println("Running CI  ")
  sh '''
    #!/bin/bash --login
    set +x

    EXPECTED_RUBY=`cat .ruby-version`

    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        source /var/lib/jenkins/.rvm/bin/rvm
    else 
        exit
    fi    
    
    rvm use default ${EXPECTED_RUBY} 
    
            ## RAILS_ENV=test bundle exec rake
    bundle exec rake
  '''
}

def RunRSpec(){
    println("Running Spec Tests ")
    sh '''
        #!/bin/bash -l
        set -x
        
        EXPECTED_RUBY=`cat .ruby-version`
        echo "EXPECTED_RUBY is ${EXPECTED_RUBY}"
        
        if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
           source /var/lib/jenkins/.rvm/bin/rvm
        else 
           exit
        fi    
        
        ## rvm use ${EXPECTED_RUBY} --default
        ## bundle install
        
        ## bin/rails exec rspec
        rspec   
    '''
}

 
def RunDeployment(railsEnv, server_ip, ssh_key){
  println("RUN Capistrano deployment ")
  withEnv(["RAILS_ENV=${railsEnv}", "SERVER_IP=${server_ip}", "SSH_KEY=${ssh_key}"]){
    sh """
        #!/bin/bash --login
        set -x
        
        EXPECTED_RUBY=`cat .ruby-version`
        echo "EXPECTED_RUBY is \$EXPECTED_RUBY"
            
        set +x
        
        if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
            source /var/lib/jenkins/.rvm/bin/rvm
        else 
            exit
        fi

        rvm list
        rvm install "\$EXPECTED_RUBY"
        rvm use "\$EXPECTED_RUBY" --default
        # whereis ruby
        ruby --version

        eval \$(ssh-agent)
        ssh-add \$SSH_KEY
        
        RAILS_ENV=staging cap staging install --trace
        RAILS_ENV=staging cap -T        
        
        ## If using GIT_HTTP_USERNAME/PASSWORD from Jenkins level, 
        ## Capistrano breaks here!
        RAILS_ENV=staging cap staging deploy:check
        RAILS_ENV=staging cap staging deploy --dry-run --trace
        RAILS_ENV=staging cap staging deploy --trace
        
        if [[ -f ./config/deploy/production.rb ]]; then 
            echo "There is ./config/deploy/production.rb created!"
            ls -alt ./config/deploy/production.rb
        else 
            echo "There is NO ./config/deploy/production.rb yet"
        fi   
    """
  }
}



=============




Following jenkinsfile and its shared library work on 09/13/2024:

=======================================09/13/2024==========
=======================================09/13/2024==========
=======================================09/13/2024==========
=======================================09/13/2024==========
=======================================09/13/2024==========
#!groovy
@Library("bpldc_lib@jenkinsfile") _

def bpl_tool = new org.bpl.bpl_tools()

pipeline {
    agent any

    environment {
        RAILS_ENV = 'test'
        // RAILS_ENV = 'staging'
    } 

    options {
        ansiColor('xterm')
    }
    
    stages {
   
                // stage('CheckoutCode') {
                //     steps {
                //         checkout([$class: 'GitSCM', 
                //             branches: [[name: '*/${BRANCH_NAME}']], 
                //             userRemoteConfigs: [[
                //                 url: "https://github.com/boston-library/Commonwealth_3.git",
                //                 credentialsId: 'bplwebmaster'
                //                 ]]
                //         ])
                //     }
                // }

        stage('CheckoutCode') {
            steps {
                script {  
                    echo "bpl_tool is ${bpl_tool}"
                    echo "In Jenkinsfile phase: Checkout Source Code" 
                    bpl_tool.CheckoutCode() 
                }
            }
        }
        
        stage('Preparation') {
            steps {
                script {  
                    echo "In Jenkinsfile phase: Preparation at the very begining"                   
                    bpl_tool.RunPreparation()
                }                
            }
        }

                // stage ('Install new ruby'){
                //     steps {
                //         sh '''
                //             #!/bin/bash -l
                //             set +x
           
                //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                //                 source /var/lib/jenkins/.rvm/bin/rvm
                //             else 
                //                 exit
                //             fi
                            
                //             EXPECTED_RUBY=`cat .ruby-version`
                //                         ## /var/lib/jenkins/.rvm/bin/rvm list
                //             echo "EXPECTED_RUBY is $EXPECTED_RUBY"
                //             set -x
                //             rvm list
                //             rvm use ${EXPECTED_RUBY} --default
                //             ruby --version
                            
                //         '''
                //     }
                // }

        stage ('Install new ruby'){
            steps {
                script {  
                    echo "In Jenkins phase: Install new ruby" 
                    // def EXPECTED_RUBY = sh(returnStdout: true, script: 'cat .ruby-version')
                    EXPECTED_RUBY = '3.2.5'
                    echo "EXPECTED_RUBY is $EXPECTED_RUBY"                    
                    bpl_tool.InstallNewRuby(EXPECTED_RUBY) 
                }
            }
        }
        
                // stage('bundle install') {
                //     steps {
                //         sh '''
                //             #!/bin/bash --login
                //             set +x
                            
                //             EXPECTED_RUBY=`cat .ruby-version`
            
                //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                //                 source /var/lib/jenkins/.rvm/bin/rvm
                //             else 
                //                 exit
                //             fi    
                            
                //             rvm use ${EXPECTED_RUBY} --default
                            
                //             bundle install --jobs=3 --retry=3
                            
                //         '''
                //     }
                // }

        stage ('Bundle Install .. '){
            steps {
                script {  
                    echo "In Jenkins phase: bundle install "                    
                    bpl_tool.RunBundleInstall() 
                }
            }
        }

        stage ('DB preparation'){
            steps {
                script {  
                    echo "In Jenkins phase: DB preparation " 
                    railsEnv = env.RAILS_ENV
                            // sh "printenv"
                    echo "railsEnv variables is : ${railsEnv}"                   
                    bpl_tool.RunDBpreparation(railsEnv) 
                }
            }
        }

                // stage('DB preparation') {
                //     steps {
                //         sh '''
                //             #!/bin/bash --login
                //             set +x
                            
                //             ls -alt
                //             EXPECTED_RUBY=`cat .ruby-version`
                        
                //             if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
                //                 source /var/lib/jenkins/.rvm/bin/rvm
                //             else 
                //                 exit
                //             fi    
                            
                //             rvm reinstall ${EXPECTED_RUBY} -C --with-jemalloc --quiet
                //             rvm get stable
                //             # rvm use ${EXPECTED_RUBY} --default 
                //             rvm alias create --default  ${EXPECTED_RUBY} 
                //             rvm alias create --current  ${EXPECTED_RUBY} 

                //             # rvm use ${EXPECTED_RUBY} --default
                //             # set -x
                            
                //             RAILS_ENV=${RAILS_ENV} bundle exec rails db:prepare
                //             RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate
                            
                //         '''
                //     }
                // }

        stage('CI') {
            steps {
                script {  
                    echo "In Jenkins phase: running CI testing "                   
                    bpl_tool.RunCI() 
                }
            }
        }

        // This deployment with two password parameters gets a warning from Jenkins:
        // insecure interpolation of sensitive variables: withEnv: [ssh_key, server_ip]
        // stage('Deploy') {
        //     steps {
        //         script {  
        //             echo "In Jenkins phase: Capistrano deploying "
        //             railsEnv = env.RAILS_ENV
        //             server_ip = env.SERVER_IP
        //             ssh_key = env.SSH_KEY
        //                     // echo "railsEnv is ${railsEnv}, server_ip is ${server_ip}, ssh_key is ${ssh_key}"              
        //             bpl_tool.RunDeployment(railsEnv, server_ip, ssh_key) 
        //         }
        //     }
        // }
        

        stage("Deploy test to use withCredentials") {
            steps {
                script {
                    echo "In Jenkins phase: Capistrano deploying "
                    railsEnv    = env.deploy_env

                    bpl_tool.RunDeployment(railsEnv)                
                }
            }
        }

        // stage('Deploy') {
        //     steps {
        //         script {

        //             sh """
        //                 #!/bin/bash --login
        //                 set -x

        //                 # STAGE_NAME=\$stage_name_password
        //                 # SERVER_IP=\$server_ip_password
        //                 # DEPLOY_USER=\$deploy_user_password
        //                 # SSH_KEY=\$ssh_key_password

        //                 # GIT_HTTP_USERNAME=\$GIT_HTTP_USERNAME_password
        //                 # GIT_HTTP_PASSWORD=\$GIT_HTTP_PASSWORD_password
    
        //                 #m# EXPECTED_RUBY=`cat .ruby-version`
        //                 EXPECTED_RUBY='3.2.5'
        //                 echo "EXPECTED_RUBY is \$EXPECTED_RUBY"
                            
        //                 set +x
                        
        //                 if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        //                     source /var/lib/jenkins/.rvm/bin/rvm
        //                 else 
        //                     exit
        //                 fi    
                        

        //                 rvm list
        //                 rvm install "\$EXPECTED_RUBY"
        //                 rvm use "\$EXPECTED_RUBY" --default
        //                 whereis ruby
        //                 ruby --version

        //                 echo "SERVER_IP is \$SERVER_IP"
        //                 echo "SSH_KEY is \$SSH_KEY"

        //                 eval \$(ssh-agent)
        //                 ssh-add \$SSH_KEY

        //                 RAILS_ENV=staging cap -T 

        //                 # bundle exec cap staging install --trace
        //                 RAILS_ENV=staging cap staging install --trace
                        
        //                 ## bundle exec cap production deploy

        //                 # bundle exec cap staging install --trace  --ssh-options="-i /var/lib/jenkins/.ssh/promdev"
        //                 # RAILS_ENV=staging cap -T
        //                 # bundle exec cap -T  --ssh-options="-i /var/lib/jenkins/.ssh/promdev"                        
                        
        //                 ## If using GIT_HTTP_USERNAME/PASSWORD from Jenkins level, 
        //                 ## Capistrano breaks here!
        //                 RAILS_ENV=staging cap staging deploy:check  
        //                 # bundle exec RAILS_ENV=staging cap staging deploy --dry-run --trace 
        //                 RAILS_ENV=staging cap staging deploy --trace  
                        
        //                 if [[ -f ./config/deploy/production.rb ]]; then 
        //                     echo "There is ./config/deploy/production.rb created!"
        //                     ls -alt ./config/deploy/production.rb
        //                 else 
        //                     echo "There is NO ./config/deploy/production.rb yet"
        //                 fi   
        //             """
        //         }            
        //     }
        //}

    }

    post {
        failure {
            emailext (
                subject: "Build failed in Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Build failed in Jenkins:</p>
                        <p>Job: ${env.JOB_NAME}</p>
                        <p>Build Number: ${env.BUILD_NUMBER}</p>
                        <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']]
            )
        }
    }

}    




======================shared library=================09/13/2024==========
#!groovy
package org.bpl

def CheckoutCode(){
  checkout([$class: 'GitSCM', 
      branches: [[name: '*/${BRANCH_NAME}']], 
      userRemoteConfigs: [[
          url: "https://github.com/boston-library/bpldc_authority_api.git",
          credentialsId: 'bplwebmaster'
          ]]
  ])
}

def GetCode(srcType,branchName,gitHttpURL,credentialsId){
    if (srcType == "git"){
        println("Downloading code from branch: ${branchName}")
        checkout([
            $class: 'GitSCM', branches: [[name: "${branchName}"]], 
            extensions: [],
            userRemoteConfigs: [[credentialsId: "{$credentialsId}", url: "${gitHttpURL}"]]
            ])
    }
}

def InstallNewRuby(rubyVersion){
   println("Installing new ruby version by being called: ${rubyVersion}")
   withEnv(["RUBYVERSION=${rubyVersion}"]){
      sh '''
      #!/bin/bash --login
 
      ## EXPECTED_RUBY=`cat .ruby-version`
      echo "ruby_version is ${RUBYVERSION}"

      source /var/lib/jenkins/.bashrc
      source /var/lib/jenkins/.bash_profile
      source /var/lib/jenkins/.profile

      if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        source /var/lib/jenkins/.rvm/bin/rvm
      else 
        exit
      fi

      echo "after sourcing rvm..."
      rvm install ${RUBYVERSION}
      ## /var/lib/jenkins/.rvm/bin/rvm get stable
      rvm use ${RUBYVERSION} --default
      rvm alias create --default  ${RUBYVERSION} 
      rvm alias create --current  ${RUBYVERSION} 

      # # bundle install
      whereis ruby
      ruby --version                    
           
      '''.stripIndent()
   }
}

def RunPreparation(){
  println("RUN bundle install ")
  sh '''
    #!/bin/bash --login

    sudo sed -i 's/port = 5433/port = 5432/' /etc/postgresql/15/main/postgresql.conf
    #sudo cp /etc/postgresql/{9.3,12}/main/pg_hba.conf
    sudo pg_ctlcluster 15 main restart
    
    export RAILS_ENV=test
    
    export PGVER=12
    export PGHOST=127.0.0.1
    export PGUSER=postgres
    export PGPASSWORD=postgres
    export PGPORT=5432
    export NOKOGIRI_USE_SYSTEM_LIBRARIES=true
    export RAILS_VERSION=6.0.5

    EXPECTED_RUBY=`cat .ruby-version`
    BUNDLE_VER=$(tail -1 ./Gemfile.lock | xargs)

    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        source /var/lib/jenkins/.rvm/bin/rvm
    else 
        exit
    fi

    set -e

    rvm install ${EXPECTED_RUBY} -C --with-jemalloc
    ## /var/lib/jenkins/.rvm/bin/rvm get stable
    rvm use ${EXPECTED_RUBY} --default 
    rvm alias create --default  ${EXPECTED_RUBY} 
    rvm alias create --current  ${EXPECTED_RUBY} 

    ruby --version


    echo "and bundle version is ${BUNDLE_VER}"
    export BUNDLE_GEMFILE=$PWD/Gemfile                
    # gem update --system --no-document
    gem update --system 
    gem install bundler:${BUNDLE_VER} --no-document
    
    ## Because previous capistrano deployment creates a new production.rb that
    ## cannot pass the CI tests. Remove it if we are in test/staging environment
    ## If in production environment, it should be passed by CI.
    if [[ -f ./config/deploy/production.rb ]]; then 
        ls -alt ./config/deploy/production.rb
        git clean -f config/deploy/production.rb
    else 
        echo "There is NO ./config/deploy/production.rb yet"
    fi 
  '''
}

def RunBundleInstall(){
  println("RUN bundle install ")
  sh '''
    #!/bin/bash -l
   
    echo "In  shared library,  bundle install" 
    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
       source /var/lib/jenkins/.rvm/bin/rvm
    else 
       exit
    fi    
    
    ## rvm use ${EXPECTED_RUBY} --default
    bundle install

  '''
}

def RunDBpreparation(railsEnv){
  println("RUN DB prepare and migrate ")
  withEnv(["RAILS_ENV=${railsEnv}"]){
    sh '''
      #!/bin/bash -l
     
      echo "RAILS_ENV from Jenkinsfile is ${RAILS_ENV}"
      echo "In  shared library,  db:prepare and db:migrate " 
      if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
         source /var/lib/jenkins/.rvm/bin/rvm
      else 
         exit
      fi    

      EXPECTED_RUBY=`cat .ruby-version`

      rvm install ${EXPECTED_RUBY}
         ## /var/lib/jenkins/.rvm/bin/rvm get stable
      rvm use ${EXPECTED_RUBY} --default
      rvm alias create --default  ${EXPECTED_RUBY} 
      rvm alias create --current  ${EXPECTED_RUBY} 
      
      # RAILS_ENV=${RAILS_ENV} bundle exec rails db:prepare
      # RAILS_ENV=${RAILS_ENV} bundle exec rails db:migrate

      bundle exec rails db:prepare
      bundle exec rails db:migrate

    '''
  }
}


def RunCI(){
  println("Running CI  ")
  sh '''
    #!/bin/bash --login
    set +x

    EXPECTED_RUBY=`cat .ruby-version`

    if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
        source /var/lib/jenkins/.rvm/bin/rvm
    else 
        exit
    fi    
    
    rvm use default ${EXPECTED_RUBY} 
    
            ## RAILS_ENV=test bundle exec rake
    bundle exec rake
  '''
}

def RunRSpec(){
    println("Running Spec Tests ")
    sh '''
        #!/bin/bash -l
        set -x
        
        EXPECTED_RUBY=`cat .ruby-version`
        echo "EXPECTED_RUBY is ${EXPECTED_RUBY}"
        
        if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
           source /var/lib/jenkins/.rvm/bin/rvm
        else 
           exit
        fi    
        
        ## rvm use ${EXPECTED_RUBY} --default
        ## bundle install
        
        ## bin/rails exec rspec
        rspec   
    '''
}

def RunDeployment(railsEnv){
  println("RUN Capistrano deployment ")
  withEnv(["RAILS_ENV=$railsEnv"]){  
    sh '''
        #!/bin/bash --login
        set -x
        
        EXPECTED_RUBY=`cat .ruby-version`
        echo "EXPECTED_RUBY is \$EXPECTED_RUBY"
            
        set +x
        
        if [ -s /var/lib/jenkins/.rvm/bin/rvm ]; then 
            source /var/lib/jenkins/.rvm/bin/rvm
        else 
            exit
        fi

        rvm list
        rvm install "\$EXPECTED_RUBY"
        rvm use "\$EXPECTED_RUBY" --default
        # whereis ruby
        ruby --version

        eval \$(ssh-agent)
        ssh-add \$SSH_KEY
        
        RAILS_ENV=\$RAILS_ENV cap staging install --trace
        RAILS_ENV=staging cap -T        
        
        ## If using GIT_HTTP_USERNAME/PASSWORD from Jenkins level, 
        ## Capistrano breaks here!
        RAILS_ENV=staging cap staging deploy:check
        RAILS_ENV=staging cap staging deploy --dry-run --trace
        RAILS_ENV=staging cap staging deploy --trace
        
        if [[ -f ./config/deploy/production.rb ]]; then 
            echo "There is ./config/deploy/production.rb created!"
            ls -alt ./config/deploy/production.rb
        else 
            echo "There is NO ./config/deploy/production.rb yet"
        fi   

        set -x
    '''
  }
}

======================shared library=================09/13/2024==========




=======================================09/13/2024==========
=======================================09/13/2024==========
=======================================09/13/2024==========
=======================================09/13/2024==========
=======================================09/13/2024==========




  -->


