pipeline {
    agent any

    environment {
        mvn = tool name: "Maven3"
    }

    options {
        timestamps()
        timeout(time: 1, unit: "HOURS")
        skipDefaultCheckout true
        buildDiscarder logRotator(artifactDaysToKeepStr: "", artifactNumToKeepStr: "", daysToKeepStr: "10", numToKeepStr: "5")
    }

    stages {
        stage("Build") {
            steps {
                echo "Checkout Source Repo.."
                checkout scm

                echo "Start Build.."
                bat "${mvn}/bin/mvn clean verify -DskipTests"
            }
        }
        stage("Test Case Execution") {
            steps {
                echo "Executing Test Cases.."
                bat "${mvn}/bin/mvn test"
            }
        }
        stage("Kubernetes Deployment") {
            steps {
                echo "Deploy pending.."
            }
        }
    }
}