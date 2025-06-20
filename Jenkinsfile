#!groovy
@Library("bpldc_jenkinsfile@main") _
// Above jenkinsfile shared library can be found here: 
// https://github.com/boston-library/jenkinsfile_shared_library

def bpl_tool = new org.bpl.bpl_tools()

pipeline {
    // agent any
    
    // This agent setting is for multibranch short 32 characters name. 
    // With this setting, project name can be any length.
    agent {
        node {
            label 'BPL_DAN'
            customWorkspace "/var/lib/jenkins/workspace/${env.JOB_NAME.replace('/', '-')}"
        }
    }


                        // parameters {
                        //     string(name: 'DEPLOY_ENV', defaultValue: 'staging', description: 'Deployment environment')
                        // }

                        // environment {
                        //     //work// RAILS_ENV = 'test'
                        //     RAILS_ENV = 'staging'
                        //     // RAILS_ENV = env.deploy_env
                        // } 

    // options {
    //     ansiColor('xterm')
    // }
    
    stages {

        stage('Print Parameter') {
            steps {
                echo "deploy_env value: ${params.deploy_env}"
                echo "DEPLOY_OR_NOT value: ${env.DEPLOY_OR_NOT}"
                
            }
        }


        stage('GetCode') {
            steps {
                script {  
                    echo "bpl_tool is ${bpl_tool}"
                    echo "In Jenkinsfile phase: Checkout Source Code" 

                    def srcType    = 'Git' 
                    def branchName = env.GIT_BRANCH
                    def gitHttpURL = env.GIT_URL
                    def credentialsId = scm.userRemoteConfigs[0].credentialsId

                    bpl_tool.GetCode(srcType,branchName,gitHttpURL,credentialsId)
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
                    def EXPECTED_RUBY = sh(returnStdout: true, script: 'cat .ruby-version')
                    // EXPECTED_RUBY = '3.2.5'
                    echo "EXPECTED_RUBY is $EXPECTED_RUBY"                    
                    bpl_tool.InstallNewRuby(EXPECTED_RUBY) 
                }
            }
        }

        stage ('Bundle Install'){
            steps {
                script {  
                    echo "In Jenkins phase: bundle install "                    
                    bpl_tool.RunBundleInstall() 
                }
            }
        }

        // stage ('DB preparation'){
        //     steps {
        //         script {  
        //             echo "In Jenkins phase: DB preparation " 
        //             def RAILS_ENV = env.deploy_env

        //             bpl_tool.RunDBpreparation(RAILS_ENV) 
        //         }
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

        stage('Create Docker Image'){
            steps {
                script {
                    if ( (env.deploy_env != 'staging') &&  ( env.deploy_env != 'production')) {
                        echo "creating docker image"
                        
                        bpl_tool.CreateDockerImage('bpldc_authority_api')
                    }else{
                        echo "No need create docker images. Skipping... "
                    }
                }
            }
        }

        stage("Deploy application to target servers") {

            // When branch is 'JFK_Capis', skip this stage
            // All other branches do deployment, for example 'master'
            // when {
            //     branch 'JFK_Capis'
            // }

            when {
                expression {
                    return env.DEPLOY_OR_NOT == 'True' || env.DEPLOY_OR_NOT == 'true'
                }
            }

            steps {
                script {
                    echo "In Jenkins phase: Capistrano deploying "
                    def RAILS_ENV = env.DEPLOY_ENV
                    echo "In Jenkinsfile, RAILS_ENV is ${RAILS_ENV}"
                    
                    //work bpl_tool.RunDeployment(env.RAILS_ENV) 
                    bpl_tool.RunDeployment(RAILS_ENV) 
                    // bpl_tool.RunDeployment()               
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
