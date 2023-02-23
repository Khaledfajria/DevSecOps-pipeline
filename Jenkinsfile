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
                        sh "pip install -r requirements.txt"
                        sh "/var/lib/jenkins/.local/bin/bumpversion --allow-dirty patch"
                        version = sh(returnStdout: true, script: "grep -o 'current_version = [0-9.]*' .bumpversion.cfg | cut -d ' ' -f 3").trim()
                        sh 'python3 setup.py sdist'
                        sh "git add . && git commit -m 'Bump version' || true"
                        sh 'git push https://${GIT_USER}:${GIT_PASS}@github.com/KhaledBenfajria/DJ-ECO.git'
                        env.IMAGE_TAG = "$version-$BUILD_NUMBER"
                    }
                }
            }
        }

        stage('Unit Tests') {
            steps {
                echo 'passs'
                //sh "pip install -r requirements.txt"
                //sh "pip install coverage"
                //sh "python3 manage.py test"
                //sh '. venv/Scripts/activate'
                sh "/var/lib/jenkins/.local/bin/coverage run --source='.' manage.py test"
                sh '/var/lib/jenkins/.local/bin/coverage xml'
                //junit '**/junit.xml'
            }
        }

        stage('SonarQube') {
            steps {
                //withEnv(["SONAR_TOKEN=${env.SONAR_TOKEN}"]) {
                    echo 'pass'
                    //sh "/home/admin/.sonar/sonar-scanner-4.7.0.2747-linux/bin/sonar-scanner -Dsonar.projectKey=django-eco -Dsonar.host.url=https://9000-port-a5233b190e794c6b.labs.kodekloud.com -Dsonar.login=sqp_cfe7a72544e6f2bb7e46af34e32dce874e219e9e"
                //}
            }
        }
        stage('Publish to Nexus') {
            steps {
                nexusArtifactUploader (
                    nexusVersion: 'nexus3',
                    protocol: 'http',
                    nexusUrl: '172.174.113.172:8081/repository/Djecommerce-artifact/',
                    version: "${version}",
                    repository: 'Djecommerce-artifact',
                    credentialsId: 'jenkins-nexus',
                    artifacts: [
                            [artifactId: 'Django-ecommerce',
                            classifier: 'package',
                            file: 'dist/Django-ecommerce-'+version+'.tar.gz',
                            type: 'tar.gz']
                     ]
                )
            }
        }

        stage('Docker Image Build and Push') {
            steps {
                echo "pass"
                sh 'sudo docker build -t my-django-ecommerce-image:${IMAGE_TAG} .'
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