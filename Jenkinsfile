node("master")
{
  checkout scm

  stage("build"){
    sh "make docker-build"
  }
  stage("push"){
    sh "make docker-push"
  }
  stage("deploy"){

    withCredentials([[$class:'FileBinding', credentialsId: 'DEV_ICELANDAIR_EU_WEST_1A', variable: 'KUBECONFIG']]){
      sh "make deployment"
    }
  }
}
