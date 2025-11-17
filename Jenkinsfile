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
                    image: "node:22"
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
                        sh 'Realizando testing'
                        sh 'npm run test:cov'
                    }
                }
                stage('Build') {
                    steps {
                        sh 'Realizando build'
                        sh 'npm run build'
                    }
                }
            }
        }
    }
}