pipeline {
    agent any

        //environment {
      //  SONAR_TOKEN = credentials('SONAR_TOKEN')
   // }

    stages {
        stage('Build Artifact') {
            steps {
                script{
                    withCredentials([usernamePassword(credentialsId: 'GIT_CRED', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                        echo 'incrementing app version...'
                        sh 'git checkout test'
                        sh 'git pull origin test'
                        sh 'rm -rf ./dist/'
                        sh "git config --global user.email 'benfajria.khaled11@gmail.com'"
                        sh "git config --global user.name 'Khaled'"
                        sh 'pip install bumpversion'
                        //def version = sh(script: 'cat version.txt', returnStdout: true).trim()
                        sh '/var/lib/jenkins/.local/bin/bumpversion --allow-dirty patch'
                        sh "pip install setuptools"
                        sh 'python3 setup.py sdist'
                        sh 'git add .'
                        sh "git commit -m 'Bump version' || true"
                        sh 'git push origin test https://${GIT_USER}:${GIT_PASS}@github.com/KhaledBenfajria/DJ-ECO.git'
                        //env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                        //echo "$env.IMAGE_TAG"
                    }
                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'pass'
                sh "pip install -r requirements.txt"
                sh "pip install coverage"
                //sh "python3 manage.py test"
                sh "/var/lib/jenkins/.local/lib/python3.8/site-packages/coverage run --source='.' manage.py test"
                sh '/var/lib/jenkins/.local/lib/python3.8/site-packages/coverage xml'
                //junit '**/junit.xml'
            }
        }

        stage('SonarQube') {
            steps {
                //withEnv(["SONAR_TOKEN=${env.SONAR_TOKEN}"]) {
                    echo 'pass'
                    sh "/home/admin/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner -Dsonar.projectKey=django-eco -Dsonar.host.url=https://9000-port-a5233b190e794c6b.labs.kodekloud.com -Dsonar.login=sqp_cfe7a72544e6f2bb7e46af34e32dce874e219e9e"
                //}
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