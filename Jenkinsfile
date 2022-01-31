pipeline {
    agent any
    
    tools {
        maven 'Maven3'
    }

    environment {
        mvn = tool name: 'Maven3'
        username = 'jiteshyadav'
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
                echo 'Checkout Source Repo..'
                checkout scm

                echo 'Start Build..'
                bat 'mvn clean verify'
            }
        }
        stage('Sonarqube Analysis') {
            steps {
                echo 'Start Sonarqube Analysis..'
                withSonarQubeEnv("SonarQubeScanner") {
                    bat "${mvn}/bin/mvn sonar:sonar -Dsonar.projectKey=sonar-${username} -Dsonar.projectName=sonar-${username}"
                }

                // Wait for results and set pipeline status accordingly
                echo 'Checking Sonar Results..'
                timeout(time: 5, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
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