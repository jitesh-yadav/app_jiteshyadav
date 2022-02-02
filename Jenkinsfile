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

        stage("Build Docker Image") {
            steps {
                echo "Building Docker Image.."
                script {
                    env.imageName = "${registry}/i-${username}-${BRANCH_NAME}:latest"
                }

                bat "docker build -t ${env.imageName} --no-cache ."
            }
        }

        stage("Push Image To DockerHub") {
            steps {
                echo "Pushing Docker Image to Docker Hub.."

                script {
                    withDockerRegistry(credentialsId: 'dockerhub', toolName: "docker") {
                        bat "docker push ${env.imageName}"
                    }
                }
            }
        }

        stage("Kubernetes Deployment") {
            steps {
                // Replace newly created image name in deployment.yaml file
                bat "sed -i 's|imageName|${env.imageName}|' k8s/deployment.yaml"
                echo "Deploying To Kubernetes Cluster.."
                bat "kubectl apply -f k8s/deployment.yaml"
            }
        }
    }
}