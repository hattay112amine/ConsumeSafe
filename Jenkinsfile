pipeline {
    agent any

    tools {
        maven 'Maven'
        jdk 'JDK21'
    }

    environment {
        APP_NAME = "consumesafe"
        DOCKER_IMAGE = "consumesafe:latest"
        DOCKER_REGISTRY = "docker.io"
    }

    stages {

        stage('Checkout') {
            steps {
                git branch: 'main',
                    url: 'https://github.com/khouloud472/ConsumeSafe.git'
            }
        }

        stage('Build Maven') {
            steps {
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Tests') {
            steps {
                sh 'mvn test'
            }
        }

        /* ================= DEVSECOPS ================= */

         stage('SonarQube Analysis') {
            steps {
                withCredentials([string(credentialsId: 'sonar-token', variable: 'SONAR_TOKEN')]) {
                    sh """
                        mvn sonar:sonar \
                        -Dsonar.projectKey=country-service \
                        -Dsonar.host.url=http://localhost:9000 \
                        -Dsonar.login=${SONAR_TOKEN}
                    """
                }
            }
        }

        stage('Dependency Scan - OWASP') {
            steps {
                sh '''
                    mvn org.owasp:dependency-check-maven:check -DfailBuildOnCVSS=7 -DskipProvidedScope=true
                '''
            }
        }

        stage('Secrets Scan - Gitleaks') {
            when {
                expression { env.GITLEAKS_ENABLED == 'true' }
            }
            steps {
                sh 'gitleaks detect --no-git -v'
            }
        }

        /* ============================================== */

        stage('Build Docker Image') {
            steps {
                script {
                    sh 'docker build -t ${DOCKER_IMAGE} .'
                    sh 'docker tag ${DOCKER_IMAGE} ${DOCKER_IMAGE}:${BUILD_NUMBER}'
                }
            }
        }

        stage('Container Scan - Trivy') {
            when {
                expression { env.TRIVY_ENABLED == 'true' }
            }
            steps {
                sh '''
                    trivy image --severity HIGH,CRITICAL --exit-code 1 ${DOCKER_IMAGE}
                '''
            }
        }

        stage('Push to Registry') {
            when {
                branch 'main'
            }
            steps {
                script {
                    sh '''
                        echo "Docker image ${DOCKER_IMAGE} is ready for deployment"
                    '''
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }
            steps {
                sh '''
                    docker-compose down || true
                    docker-compose up -d --build
                '''
            }
        }
    }

    post {
        success {
            echo 'Pipeline DevSecOps exécuté avec succès ✓'
            archiveArtifacts artifacts: 'target/*.jar,dependency-check-report.json', allowEmptyArchive: true
        }
        failure {
            echo 'Pipeline bloqué pour raison de sécurité ✗'
        }
        always {
            cleanWs()
        }
    }
}

