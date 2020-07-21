pipeline {
  environment {
    registry = "dammy092002/capstone"
    registryCredential = 'docker-hub-credentials'
    dockerImage = ''
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        git 'https://github.com/dammy092002/node-app'
  }
}
    stage('DockerLint') {
      steps {
        sh '/usr/local/sbin/hadolint-Linux-x86_64 --ignore DL3005 --ignore DL3006 --ignore DL3009 Dockerfile'
  }
}
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry + ":$BUILD_NUMBER"
        }
      }
    }
    stage('Deploy Image to Registry') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
    stage('Deploy to k8s') {
      steps{
        sh "chmod +x changeBuild.sh"
        sh "./changeBuild.sh $BUILD_NUMBER"
		sshagent(['k8s-cluster']) {
			sh "scp -o StrictHostKeyChecking=no services.yml node-app-pod.yml ubuntu@54.191.41.126:/home/ubuntu/"
			script{
				try{
					sh "ssh ubuntu@54.191.41.126 kubectl apply -f ."
				}catch(error){
					sh "ssh ubuntu@54.191.41.126 kubectl create -f ."
				}
			}
		}
	}
}
    stage('Remove Unused docker image') {
      steps{
        sh "docker rmi $registry:$BUILD_NUMBER"
      }
    }
  }
}
