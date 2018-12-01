## Problem 2 - Deploy a web application
### Automating web application deployment

#### Files:
1. deploy_application.sh
2. deployment-pipeline.Jenkinsfile
3. main.tf
4. terraform.tf
5. variables.tf
6. london.tfvars
7. README.md
**_deploy_application.sh =>_** This script can be used to deploy/upgrade ElasticBeanstalk application. Usage;
	       *./deploy_application.sh webapp.tar.gz*  
**_deployment-pipeline.Jenkinsfile =>_** This file can be configued in a Jenkins job to create the pipeline  
**_main.tf =>_** This is the main terraform file which will create aws resources  
**_terraform.tf =>_** This has terraform backend configured to save terraform state file in S3  
**_variables.tf =>_** variables to be used in terraform main file are defined here  
**_london.tfvars =>_** contains region specific information  
**_README.md =>_** instructions about this project
#### Instructions for compiling, running, or executing:  
Detailed instructions are given below in webapp.tar.gz"Deployment Plan"_
#### Integration with CI tools:  
For example: In Jenkins you need to create a job, use https://github.com/abu-malik/apptio-tech-test as git source and set "deployment-pipeline.Jenkinsfile" as jenkins file. This will ask for _tar.gz_ for example _webapp.tar.gz_ and will deploy it on AWS elasticbeanstalk
#### Tests:  
I have tested this on my local PC, an AWS instance and also from my company's PC. All worked well. We can test deployment-pipeline.Jenkinsfile in bitbucket, CodePipeline or any other CI tool. We can also test the script "deploy_application.sh" in a non-Redhat Linux OS
#### Resources: 
What external references/sources you used to arrive at the solution? 
Only external tooling like Jenkins is used. All code is written myself
#### Design and Implementation: Design choices and decisions
I used github as source code, terraform as IAAS to utilize public cloud AWS resources and Jenkins as a CI tool. The decision to choose these was mainly based on experience, flexibility and simplicity.
#### Alternatives: What alternatives did you consider? Why did you not choose those options?
Cloudformation could also be used instead of Terraform. But it's not used as it could be aws specific. Terraform can be used for any other public cloud like Azure. Jenkins and Github are used as i have experience in these. You can also use any other tool like Bamboo and Bitbucket

#### Deployment Plan: How will this be deployed?
**_Prerequisites:_**
 - Install latest Terraform version (https://www.terraform.io/downloads.html)
 - AWS Command Line Interface (https://docs.aws.amazon.com/cli/latest/userguide/awscli-install-bundle.html)
 - Configure AWS account's access_key_id and secret_access_key. Make sure the account has right permissions to manage AWS resources with right permissions (https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html)
 - Install zip package (yum install zip)
 - Install git (https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)  

**_Deployment Plan:_**  
The assignment has been tested on Redhat Linux 7.4
1. Clone the git repository (https://github.com/abu-malik/apptio-tech-test.git or using SSH URL (git@github.com:abu-malik/apptio-tech-test.git)
2. Create a s3 bucket and update terraform.tf file accordingly to save terraform state file
3. terraform init
4. terraform plan -var-file="london.tfvars"
5. terraform apply -var-file="london.tfvars"
Once apply is successful it should output “Application_URL” with default beanstalk PHP page landing page. Open the URL in a browser to make sure it’s working.
6. Next, we will deploy our application.
chmod 777 deploy_application.sh
./deploy_application.sh webapp.tar.gz
If you see the message “Deployment completed successfully” it means your application has been deployed successfully.
7. After about 3-4 minutes try refreshing the same “Application_URL” your application should have deployed already.
8. Once verified successfully and you don't need the infrastructure anymore run below to destroy the application and AWS resources
terraform destroy -var-file="london.tfvars"
#### Monitoring/Reporting/Alerts: How will your team know that your program/solution is working as expected? What metrics/charts would you monitor and report for this component?
At the moment the deployment is done ad-hoc basis. We can of course schedule it weekly, monthly or daily in Jenkins and send an email notification if the deployment fails. We can also set AWS alarms/notification in Cloudwatch, Beanstalk to monitor the deployment status
#### Configuration: What configuration parameters will this need? How will the administrators set these parameters?
We only need to set AWS account's access and secret_access_key. Details can be found at https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-getting-started.html
#### Testing: What is your test strategy?
It's a simple pipeline to automare application deployment. We can test with different directory stucture of the input tarball file and see how script "deploy_application.sh" behaves. At the moment the script run some commands based on existing directory structure. If this changes or doesn't exist the scipt might not be able to create deployment zip file and hence it will fail.
