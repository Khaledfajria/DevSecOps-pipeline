pipeline {
    agent any

    environment {
       //SONAR_TOKEN = credentials('SONAR_TOKEN')
       BUMPVERSION = "/var/lib/jenkins/.local/bin/bumpversion"
       COVERAGE    = "/var/lib/jenkins/.local/bin/coverage"
       DOCKER_REGISTRY = "http://20.163.172.235:8081"
       DOCKER_REGISTRY_CREDENTIALS = credentials('NEXUS-CRED')
    }

    stages {
        stage('Build Artifact') {
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'GIT_CRED', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        echo "incrementing app version..."
                        sh "git checkout test"
                        sh "git pull origin test"
                        sh "rm -rf ./dist/"
                        sh "pip install -r requirements.txt"
                        sh "$BUMPVERSION --allow-dirty patch"
                        version = sh(returnStdout: true, script: "grep -o 'current_version = [0-9.]*' .bumpversion.cfg | cut -d ' ' -f 3").trim()
                        sh "python3 setup.py sdist"
                        sh "git add . && git commit -m 'Bump version' || true"
                        sh "git push https://${GIT_USER}:${GIT_PASS}@github.com/KhaledBenfajria/DJ-ECO.git"
                        env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                    }
                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo "passs"
                //sh "pip install -r requirements.txt"
                //sh "pip install coverage"
                //sh "python3 manage.py test"
                //sh '. venv/Scripts/activate'
                sh "$COVERAGE run --source='.' manage.py test"
                sh "$COVERAGE xml"
                //junit '**/junit.xml'
            }
        }

        stage('SonarQube') {
            steps {
                //withEnv(["SONAR_TOKEN=${env.SONAR_TOKEN}"]) {
                    echo "pass"
                    //sh "/home/admin/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner -Dsonar.projectKey=django-eco -Dsonar.host.url=https://9000-port-a5233b190e794c6b.labs.kodekloud.com -Dsonar.login=sqp_cfe7a72544e6f2bb7e46af34e32dce874e219e9e"
                //}
            }
        }
        stage('Publish to Nexus') {
            steps {
                nexusArtifactUploader (
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '20.163.172.235:8081/repository/Djecommerce-artifact/',
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
                  docker.withRegistry("${DOCKER_REGISTRY}", "docker") {
                    sh "sudo docker build --no-cache -t my-django-ecommerce-image:${IMAGE_TAG} ."
                    sh "sudo docker tag my-django-ecommerce-image:${IMAGE_TAG} ${DOCKER_REGISTRY}/my-django-ecommerce-image:${IMAGE_TAG}"
                    sh "sudo docker push ${DOCKER_REGISTRY}/my-django-ecommerce-image:${IMAGE_TAG}"
                  }
                }
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                echo "pass"
                //Install k8s-cli plugin
                //withKubeConfig([credentialsId: 'kubeconfig']) {
                   // sh "sed -i 's#replace-image#my-django-ecommerce-image:$BUILD_NUMBER#g' DJ-ecommerce-deploy.yaml"
                   // sh "kubectl apply -f DJ-ecommerce-deploy.yaml"
               // }
            }
        }
    }
}