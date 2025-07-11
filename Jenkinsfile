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

    options {
        ansiColor('xterm')
    }
    
    stages {
        // DEPLOY_ENV value is set to `null` if it cannot be found in Jenkinsfile
        // Since capistrano deployment is only for staging/production, Jenkins configs will
        // provide value to `DEPLOY_ENV` (staging, produciton). 
        stage('Print Parameter') {
            steps {
                echo "DEPLOY_ENV value: ${env.DEPLOY_ENV}"
                echo "\033[42m\033[97D DEPLOY_OR_NOT value: ${env.DEPLOY_OR_NOT}\033[0m"
                echo "WORKSPACE_TMP: ${env.WORKSPACE_TMP}"
                echo "JOB_DISPLAY_URL: ${env.JOB_DISPLAY_URL}"
                echo "RUN_ARTIFACTS_DISPLAY_URL: ${env.RUN_ARTIFACTS_DISPLAY_URL}"
                echo "fullDisplayName: ${currentBuild.fullDisplayName}"
                echo "externalizableId: ${currentBuild.externalizableId}"
                echo "absoluteUrl: ${currentBuild.absoluteUrl}"
                echo "buildVariables: ${currentBuild.buildVariables}"
                echo "JOB_BASE_NAME: ${env.JOB_BASE_NAME}"
                echo "JOB_NAME: ${env.JOB_NAME}"
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
                    // all environments, including staging/production, need ruby/capistrano installation
                    echo "In Jenkins phase: bundle install " 
                    // Test for failure pipeline and send email from pipeline   
                    bpl_tool.RunBundleInstal()
                    // good ! // bpl_tool.RunBundleInstall() 
                }
            }
        }

        // DB Preparation is not necessary sometimes.
        //
        // stage ('DB preparation'){
        //     steps {
        //         script {  
        //              // staging/production doesn't need DB preparation
        //              // This is only for Jenkins branch build
        //             echo "In Jenkins phase: DB preparation "
        //             def RAILS_ENV = env.DEPLOY_ENV
        //             bpl_tool.RunDBpreparation(RAILS_ENV) 
        //         }
        //     }
        // }

        stage('CI') {
            steps {
                script {  
                    // staging/production still do a rspec testing for ruby codes.
                    // it may skip
                    if ( (env.DEPLOY_ENV != 'staging') &&  ( env.DEPLOY_ENV != 'production')) {
                        echo "In Jenkins phase: running CI testing "                   
                        bpl_tool.RunCI() 
                    }else{
                        echo "No need run rspec tests in staging/production. Skipping... "
                    }
                }
            }
        }

        stage('Create Docker Image'){
            steps {
                script {
                    // staging/production doesn't need to create docker image
                    if ( (env.DEPLOY_ENV != 'staging') &&  ( env.DEPLOY_ENV != 'production')) {
                        echo "creating docker image"
                        
                        bpl_tool.CreateDockerImage('bpldc_authority_api')
                    }else{
                        echo "No need create docker images. Skipping... "
                    }
                }
            }
        }

        stage("Deploy application to target servers") {

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

        // If job_name has "deploy" inside, it will not trigger downstream deployment!
        // For example, if "deploy_prod" job, it will stop trigger other project
        // stage('Trigger Downstream') {
        //     when {
        //         expression {
        //             // Only trigger if JOB_NAME contains "deploy"
        //             return !env.JOB_NAME.contains('deploy')
        //         }
        //     }
        //     steps {
        //         script {
        //             echo 'Triggering other projects...'
        //             build job: 'bpldc_jenkinsfile_deploy_test_capistrano', wait: false
        //             build job: 'bpldc_jenkinsfile_deploy_STAGING_capistrano', wait: false
        //         }
        //     }
        // }

    }

    // If job_name has "deploy" inside, it will not trigger downstream deployment!
    // For example, if "deploy_prod" job, it will stop trigger other project
    post {
        success {
            script {
                if (!env.JOB_NAME.contains('deploy')) {
                    echo 'Triggering other projects...'
                    build job: 'bpldc_jenkinsfile_deploy_test_capistrano', wait: false
                    build job: 'bpldc_jenkinsfile_deploy_STAGING_capistrano', wait: false
                }
            }
        }

        failure {
            emailext (
                subject: "Build failed in Jenkins: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
                body: """<p>Build failed in Jenkins:</p>
                        <p>Job: ${env.JOB_NAME}</p>
                        <p>Build Number: ${env.BUILD_NUMBER}</p>
                        <p>Build URL: <a href="${env.BUILD_URL}">${env.BUILD_URL}</a></p>""",
                recipientProviders: [[$class: 'DevelopersRecipientProvider']],
                to: 'rmiao@bpl.org, bbarber@bpl.org'
            )
        }
    }

}    
