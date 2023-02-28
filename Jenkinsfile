pipeline {
    agent any

    environment {
       //SONAR_TOKEN = credentials('SONAR_TOKEN')
       BUMPVERSION = "/var/lib/jenkins/.local/bin/bumpversion"
       COVERAGE    = "/var/lib/jenkins/.local/bin/coverage"
       DOCKER_REGISTRY = "http://52.249.250.21:8070/repository/docker"
       DOCKER_REGISTRY_CREDENTIALS = credentials('NEXUS-CRED')
    }

    stages {
        stage('Checkout Code') {
            steps {
                script {
                    sh "git checkout test"
                    sh "git pull origin test"
                }
            }
        }
        stage('Install Dependencies') {
            steps {
                sh "pip install -r requirements.txt"
            }
        }
        stage('increment version') {
            steps {
                script {
                    echo "incrementing app version..."
                    sh "$BUMPVERSION --allow-dirty patch"
                    version = sh(returnStdout: true, script: "grep -o 'current_version = [0-9.]*' .bumpversion.cfg | cut -d ' ' -f 3").trim()
                    env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                }
            }
        }
        stage('Build Artifact') {
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'GIT_CRED', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        sh "rm -rf ./dist/"
                        sh "python3 setup.py sdist"
                        sh "git add . && git commit -m 'Bump version' || true"
                        sh "git push https://${GIT_USER}:${GIT_PASS}@github.com/KhaledBenfajria/DevSecOps-pipeline.git"

                    }
                }
            }
        }

        stage('Unit Tests') {
            steps {
                sh "$COVERAGE run --source='.' manage.py test"
                sh "$COVERAGE xml"

            }
        }

//        stage('Check for security vulnerabilities') {
//            steps {
//                sh "safety check "
//            }
//        }


//        stage('SonarQube') {
//            steps {
//                //withEnv(["SONAR_TOKEN=${env.SONAR_TOKEN}"]) {
//                    echo "pass"
//                    //sh "/home/admin/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner -Dsonar.projectKey=django-eco -Dsonar.host.url=https://9000-port-a5233b190e794c6b.labs.kodekloud.com -Dsonar.login=sqp_cfe7a72544e6f2bb7e46af34e32dce874e219e9e"
//                //}
//            }
//        }
//        stage('Publish Artifact to Nexus') {
//            steps {
//                nexusArtifactUploader (
//                    nexusVersion: 'nexus3',
//                    protocol: 'http',
//                    nexusUrl: '52.249.250.21:8081/repository/Djecommerce-artifact/',
//                    groupId: 'zed',
//                    version: "${version}",
//                    repository: 'Djecommerce-artifact',
//                    credentialsId: 'NEXUS-CRED',
//                    artifacts: [
//                            [artifactId: 'Django-ecommerce',
//                            classifier: 'file',
//                            file: 'dist/Django-ecommerce-'+version+'.tar.gz',
//                            type: 'tar.gz']
//                     ]
//                )
//            }
//        }

//        stage('Build & Push Docker image to Nexus') {
//            steps {
//                script {
//                  docker.withRegistry("${DOCKER_REGISTRY}", "NEXUS-CRED") {
//                    sh "sudo docker build --no-cache -t my-django-ecommerce-image:${IMAGE_TAG} ."
//                    sh "sudo docker tag my-django-ecommerce-image:${IMAGE_TAG} 52.249.250.21:8070/repository/docker/my-django-ecommerce-image:${IMAGE_TAG}"
//                    sh "sudo docker push 52.249.250.21:8070/repository/docker/my-django-ecommerce-image:${IMAGE_TAG}"
//                  }
//                }
//            }
//        }
//
//        stage('Kubernetes Deployment') {
//            steps {
//                echo "pass"
//                //Install k8s-cli plugin
//                //withKubeConfig([credentialsId: 'kubeconfig']) {
//                   // sh "sed -i 's#replace-image#my-django-ecommerce-image:$BUILD_NUMBER#g' DJ-ecommerce-deploy.yaml"
//                   // sh "kubectl apply -f DJ-ecommerce-deploy.yaml"
//               // }
//            }
//        }
    }
}