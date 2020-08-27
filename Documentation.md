TOOLS USED:
  - GIT
  - DOCKER
  - AWS CODEPIPELINE
  - AWS ECR
  - AWS EKS
  - TERRAFORM
  
OBJECTIVE: To build a scalable app that is highly available and persistent using AWS services

ASSUMPTIONS: 
  - Tools used must be AWS native
  - Used GIT so that the code can be reviewed by the panel
  - Used TERRAFORM as it can be used to deploy infra on most cloud solutions
  - Used EKS as the kubernetes manifests can be used on other cloud solutions with minor modifications
  - EKS cluster has two worker nodes for Highavailability (should have configured three)
  
TOOLS CONSIDERED BUT NOT USED:
  - Jenkins [Has good plugins base and is not cloud native but wanted to use native AWS services]
  - Dockerhub [Not cloud native but wanted to use native AWS services]
  
HOW DOES THE APP WORK:
  - Deploy AWS EKS cluster using terraform
  - Configure AWS CODEPIPELINE with necessary Environment Variables
  - Edit the aws-auth configmap to allow codebuild to make changes to the cluster
  - Create an ingress rule on worker nodes security group to open ephermal ports 30000-32767
  - Create a repository on GIT and configure webhook
  - Push the code to GIT repository
  - Pipeline is triggered and docker images built are pushed to the AWS ECR repository
  - Repository information and tag for respective images are modified for the k8s manifests
  - Postgres is deployed with persistence volume and is only available with in the cluster
  - Web app is exposed as a node port service on port 30010 --> http://worker-node-ip:30010
  - Api app is exposed as a node port service on port 30020 --> http://worker-node-ip:30020/api/status
  
KNOWN SECURITY ISSUES:
