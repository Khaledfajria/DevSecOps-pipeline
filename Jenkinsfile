pipeline {
    agent any

    stages {
        stage('Build Artifact') {
            steps {
                //sh 'sudo apt install pip -y'
                //sh 'python3 -m pip install --upgrade pip'
                //sh 'python3 -m venv'
                //sh 'source venv/bin/activate'
                //sh 'pip install virtualenv --target=/var/lib/jenkins/workspace/django'
                //sh '$VIRTUALENV_EXECUTABLE env'
                //sh 'source env/bin/activate'
                //sh 'pip install --no-cache-dir -r requirements.txt'
                echo "pass"
                //sh 'python manage.py collectstatic'
                //archiveArtifacts artifacts: '**/dist/*.tar.gz', excludes: 'dist/build'
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
                //sh 'docker push my-django-ecommerce-image'
            }
        }

        stage('Kubernetes Deployment') {
            steps {
                echo "pass"
                //Install k8s-cli plugin
                withKubeConfig([credentialsId: 'kubeconfig']) {
                    sh "sed -i 's#replace-image#my-django-ecommerce-image:$BUILD_NUMBER#g' DJ-ecommerce-deploy.yaml"
                    sh 'kubectl apply -f DJ-ecommerce-deploy.yaml'
                }
            }
        }
    }
}