pipeline {
    agent any

    stages {
        stage('Build Artifact') {
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'GIT_CRED', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        echo 'incrementing app version...'
                        sh 'git checkout master'
                        sh 'git pull'
                        sh 'rm -rf ./dist/'
                        sh 'git config --global user.email "benfajria.khaled11@gmail.com"'
                        sh 'git config --global user.name "Khaled"'
                        sh 'pip install bumpversion'
                        //def version = sh(script: 'cat version.txt', returnStdout: true).trim()
                        sh '/var/lib/jenkins/.local/bin/bumpversion --allow-dirty patch'
                        sh "pip install setuptools"
                        sh 'python3 setup.py sdist'
                        sh 'git add .'
                        sh "git commit -m 'Bump version'"
                        sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/KhaledBenfajria/DJ-ECO.git'
                        //env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                        //echo "$env.IMAGE_TAG"
                    }
                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'pass'
                //sh 'python3 manage.py test'
                //junit '**/junit.xml'
            }
        }

        stage('SonarQube') {
            steps {
                echo 'pass'
                sonar-scanner -Dsonar.projectKey=django-eco -Dsonar.sources=. -Dsonar.host.url=https://9000-port-b2d66ea8ecf04937.labs.kodekloud.com
            }
        }

        stage('Docker Image Build and Push') {
            steps {
                echo "pass"
                //sh 'sudo docker build -t my-django-ecommerce-image:${IMAGE_TAG} .'
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                echo "pass"
                //Install k8s-cli plugin
                //withKubeConfig([credentialsId: 'kubeconfig']) {
                   // sh "sed -i 's#replace-image#my-django-ecommerce-image:$BUILD_NUMBER#g' DJ-ecommerce-deploy.yaml"
                   // sh 'kubectl apply -f DJ-ecommerce-deploy.yaml'
               // }
            }
        }
    }
}