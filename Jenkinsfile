pipeline {
    agent any

    stages {
        stage('Build Artifact') {
            steps {
                script{
                    echo 'incrementing app version...'
                    sh 'rm -rf ./dist/'
                    sh 'git config --global user.email "you@example.com"'
                    sh 'git config --global user.name "Your Name"'
                    sh 'pip install bumpversion'
                    sh '/var/lib/jenkins/.local/bin/bumpversion --allow-dirty patch'
                    def version = sh(script: 'cat version.txt', returnStdout: true).trim()
                    echo "The version is: $version"
                    env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                    echo "$env.IMAGE_TAG"
                    //sh "pip install setuptools"
                    //sh 'python3 setup.py sdist'

                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'pass'
                //sh 'python manage.py test'
                //junit '**/junit.xml'
            }
        }

        stage('Docker Image Build and Push') {
            steps {
                echo "pass"
                sh 'sudo docker build -t my-django-ecommerce-image:$BUILD_NUMBER .'
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