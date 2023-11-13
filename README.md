# Tableau Bridge for Linux

This repository provides the resources required to deploy Tableau Bridge in a container in a variety of potential environments.

## Deployment Options

### Individual Machine

Deploying Tableau Bridge on an individual machine involves setting up a Docker container in a Linux environment. The resources in this repository use Ansible to make the deploymeny of the Bridge client as hands off as possible. This method is suitable for small-scale on-premises deployments.

### AWS ECS Service

Deploying Tableau Bridge using AWS ECS (Elastic Container Service) offers scalability and integration with AWS's cloud infrastructure. These resources leverage Terraform to automate the provison of the resources required to get Bridge running in ECS. This is ideal for larger-scale environments where Tableau Cloud needs to connect to data in AWS that is not publically accessible.
