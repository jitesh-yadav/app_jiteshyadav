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
                script {
                    def deployment_yaml = readFile file: "k8s/deployment.yaml"
                    deployment_yaml = deployment_yaml.replaceAll("imageName", "${env.imageName}")
                    writeFile file: "k8s/deployment.yaml", text: deployment_yaml
                }

                echo "Deploying To Kubernetes Cluster.."
                bat "kubectl apply -f k8s/deployment.yaml"
            }
        }
    }
}