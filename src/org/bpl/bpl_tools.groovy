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
      /var/lib/jenkins/.rvm/bin/rvm install ${RUBYVERSION}
      ## /var/lib/jenkins/.rvm/bin/rvm get stable
      /var/lib/jenkins/.rvm/bin/rvm use ${RUBYVERSION} --default
      /var/lib/jenkins/.rvm/bin/rvm alias create --default  ${RUBYVERSION} 
      /var/lib/jenkins/.rvm/bin/rvm alias create --current  ${RUBYVERSION} 

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

    /var/lib/jenkins/.rvm/bin/rvm install ${EXPECTED_RUBY} -C --with-jemalloc
    ## /var/lib/jenkins/.rvm/bin/rvm get stable
    /var/lib/jenkins/.rvm/bin/rvm use ${EXPECTED_RUBY} --default 
    /var/lib/jenkins/.rvm/bin/rvm alias create --default  ${EXPECTED_RUBY} 
    /var/lib/jenkins/.rvm/bin/rvm alias create --current  ${EXPECTED_RUBY} 

    ruby --version


    echo "and bundle version is ${BUNDLE_VER}"
    export BUNDLE_GEMFILE=$PWD/Gemfile                
    ## gem update --system --no-document
    gem update
    gem install bundler:${BUNDLE_VER}
    
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

      /var/lib/jenkins/.rvm/bin/rvm install ${EXPECTED_RUBY}
         ## /var/lib/jenkins/.rvm/bin/rvm get stable
      /var/lib/jenkins/.rvm/bin/rvm use ${EXPECTED_RUBY} --default
      /var/lib/jenkins/.rvm/bin/rvm alias create --default  ${EXPECTED_RUBY} 
      /var/lib/jenkins/.rvm/bin/rvm alias create --current  ${EXPECTED_RUBY} 
      
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
        pwd
        whoami
        ls -alt 
        
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
  withEnv(["RAILS_ENV=${railsEnv}" "SERVER_IP=${server_ip}" "SSH_KEY=${ssh_key}"]){
    sh """
        #!/bin/bash --login
        set -x
        
        ## STAGE_NAME=\$stage_name_password
        #m# SERVER_IP=\$server_ip_password
        #m# DEPLOY_USER=\$deploy_user_password
        #m# SSH_KEY=\$ssh_key_password
        #m# TESTING_SUDO_PASSWORD=\$sudo_pass_password
        ## GIT_HTTP_USERNAME=\$GIT_HTTP_USERNAME_password
        ## GIT_HTTP_PASSWORD=\$GIT_HTTP_PASSWORD_password

        echo "From shared library, railsEnv is \$RAILS_ENV"
        echo "From shared library, server_ip is \$SERVER_IP"
        echo "From shared library, ssh_key is \$SSH_KEY"
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
        whereis ruby
        ruby --version

        echo "Rongbing Miao#1"
        ## echo "GIT_HTTP_USERNAME is \$GIT_HTTP_USERNAME"
        ## echo "GIT_HTTP_PASSWORD is \$GIT_HTTP_PASSWORD"
        echo "SERVER_IP is \$SERVER_IP"
        echo "SSH_KEY is \$SSH_KEY"
        echo "Rongbing Miao#2"

        #m# RAILS_ENV=staging cap staging install --trace
        #m# RAILS_ENV=staging cap -T
        #m# RAILS_ENV=${RAILS_ENV} cap staging install --trace
        bundle exec RAILS_ENV=${RAILS_ENV} cap staging install --trace  --ssh-options="-i /var/lib/jenkins/.ssh/promdev"
        #m# RAILS_ENV=${RAILS_ENV} cap -T  
        bundle exec RAILS_ENV=${RAILS_ENV} cap -T --ssh-options="-i /var/lib/jenkins/.ssh/promdev"
        
        
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
