pipeline {
    agent any

    tools {
        maven 'Maven3'
    }

    options {
        timestamp()
        timeout(time: 1, unit: 'HOURS')
        buildDiscarder logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '10', numToKeepStr: '5')
    }

    stages {
        stage('Checkout code') {
            steps {
                git url: 'https://github.com/jitesh-yadav/app_jiteshyadav_nagp_devops.git'
            }
        }
        stage('Build') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }
    }
}