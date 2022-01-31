pipeline {
    agent any
    
    tools {
        maven 'Maven3'
    }

    options {
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        skipDefaultCheckout true
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '5')
    }

    stages {
        stage('Build') {
            steps {
                checkout scm
                bat 'mvn clean install'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                echo 'Analysis pending..'
            }
        }
        stage('Kubernetes Deployment') {
            steps {
                echo 'Deploy pending..'
            }
        }
    }
}