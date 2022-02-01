pipeline {
    agent any

    environment {
        mvn = tool name: "Maven3"
        username = "jiteshyadav"
        registry = "jiteshyadav"
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
                echo "Checking out Source Repo.."
                checkout scm

                echo "Starting Build.."
                bat "${mvn}/bin/mvn clean verify"
            }
        }
        stage("Sonarqube Analysis") {
            steps {
                echo "Starting Sonarqube Analysis.."
                withSonarQubeEnv("Test_Sonar") {
                    bat "${mvn}/bin/mvn sonar:sonar -Dsonar.projectKey=sonar-${username} -Dsonar.projectName=sonar-${username}"
                }

                // Wait for results and set pipeline status accordingly
                echo "Checking Sonar Results.."
                timeout(time: 5, unit: "MINUTES") {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Kubernetes Deployment") {
            environment {
                imageName = "i-${username}-${BRANCH_NAME}:${BUILD_NUMBER}"
            }
            steps {
                echo "Building Docker Image.."
                bat "docker build -t ${registry}/${imageName} --no-cache ."

                echo "Pushing Docker Image to Docker Hub.."
                script {
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: "docker") {
                        bat "docker push ${registry}/${imageName}"
                    }
                }

                echo "Deploying To Kubernetes Cluster.."
                bat "kubectl apply -f k8s/deployment.yaml"
            }
        }
    }
}