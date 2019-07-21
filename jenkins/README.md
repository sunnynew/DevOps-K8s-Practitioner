Install Jenkins as docker container
----------------------------------
Steps: running jenkins on bastion host. 

1). Docker build using Dockerfile, tag as jenkins:v1

	docker build -t jenkins:v1 .

2). Run jenkins docker container

	docker run -itd -p 8080:8080 -p 50000:50000 --name jenkins --env JAVA_OPTS="-Djenkins.install.runSetupWizard=false" jenkins:v1

3). Open <bastion-IP>:8080 in browser

* NOTE: You can exclude "-Djenkins.install.runSetupWizard=false" option, just added to avoid Setup wizard when you open jenkins for the first time.	


Configuring kubectl in Jenkins for Continuous Deployment
--------------------------------------------------------
Now, let’s configure the Kubernetes credentials so Jenkins can deploy to our Kubernetes cluster. We have to create a ServiceAccount in Kubernetes that will be used by Jenkins for deployment.

Run below commands on bastion host, kubectl already configured on it. [done by kubespray/kubespray-setup.sh]

	- kubectl create sa jenkins-deployer

	- kubectl create clusterrolebinding jenkins-deployer-role --clusterrole=cluster-admin --serviceaccount=default:jenkins-deployer

	- kubectl get secrets

	- kubectl describe secret jenkins-deployer-token-<id>

	NOTE: We will use token string to create credentials in jenkins. Copy token.


Now, Go to Jenkins -> Credentials in the left menu of the main page, then choose System, and Add domain. You can add the name of your company for example. Then click on Add credentials in the left menu.

Fill in the form as follows:
 - Kind: Secret text
 - Scope: Global
 - Secret: the token copied from jenkins-deployer-token-<id> (long string)
 - ID: jenkins-deployer-credentials (same ID we will use in the function withKubeConfig in the Jenkinsfile)


Creating Jenkins Job
- Go to the main page of Jenkins, click on New Item in the left menu. Then indicate a Job name and select Pipeline as Job type. 
- Finally, go to the Pipeline section and configure it.
