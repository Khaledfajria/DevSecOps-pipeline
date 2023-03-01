pipeline {
    agent any

    environment {
       //SONAR_TOKEN = credentials('SONAR_TOKEN')
       BIN_PATH = "/var/lib/jenkins/.local/bin"
       DOCKER_REGISTRY = "http://104.45.211.160:8070/repository/docker"
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
                    sh "$BIN_PATH/bumpversion --allow-dirty patch"
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
                sh "$BIN_PATH/coverage run --source='.' manage.py test"
                sh "$BIN_PATH/coverage xml"

            }
        }

        stage('Vulerability Scan') {
            steps {
                parallel(
                    "DependencyCheck": {
                        sh "$BIN_PATH/safety check -r requirements.txt --continue-on-error " //--output json > report.json
                    },
                    "TrivyScan": {
                        sh "bash TrivyScan-docker-image.sh"
                    },
                    "OPA Conftest": {
                        sh "sudo docker run --rm  -v \$(pwd):/project openpolicyagent/conftest test --policy Dockerfile-security.rego Dockerfile"
                    }
                )
            }
        }


//        stage('SonarQube - SAST') {
//            steps {
//                //withEnv(["SONAR_TOKEN=${env.SONAR_TOKEN}"]) {
//                    echo "pass"
//                    sh "/home/bob/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner -Dsonar.projectKey=django-eco -Dsonar.host.url=https://9000-port-7dc2c4d04c564edc.labs.kodekloud.com -Dsonar.login=sqp_83f1a8972c33740851a38c469d87c4eb694dcacb"
//                }
//        }

        stage('Publish Artifact to Nexus') {
            steps {
                nexusArtifactUploader (
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '104.45.211.160:8081/repository/Djecommerce-artifact/',
                    groupId: 'zed',
                    version: "${version}",
                    repository: 'Djecommerce-artifact',
                    credentialsId: 'NEXUS-CRED',
                    artifacts: [
                            [artifactId: 'Django-ecommerce',
                            classifier: 'file',
                            file: 'dist/Django-ecommerce-'+version+'.tar.gz',
                            type: 'tar.gz']
                     ]
                )
            }
        }

        stage('Build & Push Docker image to Nexus') {
            steps {
                script {
                  docker.withRegistry("${DOCKER_REGISTRY}", "NEXUS-CRED") {
                    sh "sudo docker build --no-cache -t my-django-ecommerce-image:${IMAGE_TAG} ."
                    sh "sudo docker tag my-django-ecommerce-image:${IMAGE_TAG} 104.45.211.160:8070/repository/docker/my-django-ecommerce-image:${IMAGE_TAG}"
                    sh "sudo docker push 104.45.211.160:8070/repository/docker/my-django-ecommerce-image:${IMAGE_TAG}"
                  }
                }
            }
        }

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