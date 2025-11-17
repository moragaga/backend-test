pipeline {
    agent any
    stages {
        stage('Inicio Pipeline') {
            steps {
                echo 'Iniciando pipeline'
            }
        }
        stage('Proceso aplicación') {
            agent {
                docker {
                    image "node:22"
                }
            }
            stages {
                stage('Construcción') {
                    steps {
                        sh 'echo "Inicio construcción aplicación"'
                    }
                }
                stage('Dependencias') {
                    steps {
                        sh 'echo "Instalando dependencias"'
                        sh 'npm install'
                    }
                }
                stage('Lint') {
                    steps {
                        sh 'echo "Realizando Lint"'
                        sh 'npm run lint'
                    }
                }
                stage('Test y Coverage') {
                    steps {
                        sh 'echo Realizando testing'
                        sh 'npm run test:cov'
                    }
                }
                stage('Build') {
                    steps {
                        sh 'echo Realizando build'
                        sh 'npm run build'
                    }
                }
            }
        }
        stage('Construir imagen docker') {
            steps {
                echo 'Iniciando Delivery'
                sh 'docker build -t backend-test-lab3 .'
                script {
                    docker.withRegistry("https://index.docker.io/v1/", "crendencial-docker-hub") {
                        sh 'docker tag backend-test-lab3 gmoragacm/backend-test-lab3'
                        sh "docker tag backend-test-lab3 gmoragacm/backend-test-lab3:${env.BUILD_NUMBER}"
                        sh 'docker push gmoragacm/backend-test-lab3'
                        sh "docker push gmoragacm/backend-test-lab3:${env.BUILD_NUMBER}"

                    }
                    docker.withRegistry("https://ghcr.io", "crendencial-git-hub") {
                        sh 'docker tag backend-test-lab3 ghcr.io/moragaga/backend-test'
                        sh "docker tag backend-test-lab3 ghcr.io/moragaga/backend-test:${env.BUILD_NUMBER}"
                        sh 'docker push ghcr.io/moragaga/backend-test'
                        sh "docker push ghcr.io/moragaga/backend-test:${env.BUILD_NUMBER}"
                    }
                }
                echo 'Fin Delivery'
            }
        }
        stage('Despliegue Continuo') {
            agent {
                docker {
                    image 'alpine/k8s:1.32.2'
                    reuseNode true
                }
            }
            steps {
                withKubeConfig([credentialsId: 'kubeconfig-docker']) {
                    sh "kubectl -n gmoraga set image deployments gmoraga-dp gmoraga-app-backend-test-lab3=gmoragacm/backend-test-lab3:${env.BUILD_NUMBER}"
                }
            }
        }
        stage('Fin Pipeline') {
            steps {
                echo 'Finalizando pipeline'
            }
        }
    }
}