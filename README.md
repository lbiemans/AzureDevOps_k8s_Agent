# AzureDevOps_k8s_Agent

This repository contains a small how-to on running a Azure Devops agent inside your own k8s cluster.

I assume you already have a k8s cluster up and running as well as an Agent pool inside Azure Devops.

First steps:

- Create a PAT (Personal Access Token) which you wil need later on, see: https://docs.microsoft.com/en-us/azure/devops/organizations/accounts/use-personal-access-tokens-to-authenticate?view=azure-devops&tabs=Windows
- Build your own Docker image which you use later on to run the agent, I use the Debian bullseye image and our own in house container registry (Harbor):

Check out this repository and run:
docker build inhouseharbor.foo.bar/myagentrepository/azuredevopsrunner:latest .
docker image push inhouseharbor.foo.bar/myagentrepository/azuredevopsrunner:latest

You should now have an image that's capable of running the agent. Let's go forward to the k8s part.

- Login to one of your k8s nodes and create a k8s secret, for this how-to I'll use the Default namespace
kubectl create secret generic azdevops   --from-literal=AZP_URL=https://dev.azure.com/MyCompany   --from-literal=AZP_TOKEN=<YOUR_PAT>   --from-literal=AZP_POOL=<POOL_NAME>

- Create the ReplicationController:
Change the image name inside the ReplicationController.yaml file and deploy the file using:
kubectl apply -f ReplicationController.yaml

If you go to the Agents tab of your Agent pools (Project Settings - Agent pools - <Pool Name> - Agents) you should now see your k8s agent.