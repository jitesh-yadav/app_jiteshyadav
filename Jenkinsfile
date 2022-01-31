pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    options {
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '5')
    }

    stages {
        stage('Build') {
            steps {
                git url: 'https://github.com/jitesh-yadav/app_jiteshyadav_nagp_devops.git'
                bat 'mvn clean install'
            }
        }
        if(branch == 'master') {
            stage('Test Case Execution') {
                steps {
                    bat 'mvn test'
                }
            }
        }
        if(branch == 'develop') {
            stage('Sonarqube Analysis') {
                steps {
                    echo 'Analysis pending..'
                }
            }
        }
        stage('Kubernetes Deployment') {
            steps {
                echo 'Deploy pending..'
            }
        }
    }
}