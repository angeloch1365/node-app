# Potential Improvements 

## Creating a Jenkins Slave Node 

Jenkins Jobs are resource intensive. With a slave node in place, larger build jobs can be done on that node so that the Master node can focus on smaller job and performing its "Master" duties. (Running Jenkins)

[Slave Node Setup](https://wiki.jenkins.io/display/JENKINS/Distributed+builds)

## Update Documentation to include Windows setup
The current documentation covers setting everything up in Linux. Everything is compatitble with Windows as well. 

## Add more types of Builds and Exmaples
There is one specific build right now taking place. It can be changed and updated but more examples would help show the power of the pipeline.

## CloudFormation Template for Initial Ec2 Instance Deployment and Docker install
There is a manual step to deploy and Ec2 instance and install Docker. This can easily be completed with a Cloudformation Template.

## Setup Terraform to scale with better State File Handling
Right now there is one s3 bucket that is being used for the state file. To scale to multiple apps, we can create a folder in the s3 bucket and updated the Main TF File of a new stack to 
create a new app folder in there. There is no cleanup process for state files so it would be invonvinient to go through each file and find out which ones are no longer needed

## Configure a seperate Jenkins Job for stack destroys
Destroying a stack is a manual process as this moment. A seperate job using a dockerfile for stack removals would be ideal for easier management

## Scale to use multiple stacks
At the moment only one stack is able to be created at a time. This is only an example pipeline to show to power of Jenkins, a seperate build script that allows for multiple stacks with limits
would be great.