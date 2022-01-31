pipeline {
    agent any

    options {
        timestamps()
        timeout(time: 1, unit: 'HOURS')
        skipDefaultCheckout true
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '5')
    }

    stages {
        stage('Build') {
            tools {
                maven 'Maven3'
            }
            steps {
                checkout scm
                bat 'mvn clean install'
            }
        }
        stage('Test Case Execution') {
            steps {
                bat 'mvn test'
            }
        }
        stage('Kubernetes Deployment') {
            steps {
                echo 'Deploy pending..'
            }
        }
    }
}