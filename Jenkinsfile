pipeline{
	agent any
	environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub')
	}
	stages {
		stage('init'){
			steps {
				sh "docker rm -f \$(docker ps -aq) || true"
				sh "docker rmi -f \$(docker images) || true"
			}
		}
		stage('build'){
			steps {
				sh "chmod +x deploy.sh"
				sh "sh deploy.sh"
			}
		}
		stage('test'){
			steps {
				sh "trivy fs ."
			}
		}
		stage('push'){
			steps {
				sh "echo \$DOCKERHUB_CREDENTIALS_PSW | docker login -u \$DOCKERHUB_CREDENTIALS_USR --password-stdin"
				sh "docker tag mysql joedev0ps/mysql:latest"
				sh "docker tag flask-app joedev0ps/flask-app:latest"
				sh "docker push joedev0ps/mysql:latest"
				sh "docker push joedev0ps/flask-app:latest"
			}
		}
	}
}
