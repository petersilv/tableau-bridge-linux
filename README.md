# Tableau Bridge for Linux

This repository provides the resources required to deploy Tableau Bridge in a container in a variety of potential environments.

## Deployment Options

### Individual Machine

Deploying Tableau Bridge on an individual machine involves setting up a Docker container in a Linux environment. This method is suitable for small-scale on-premises deployments.

- **Bash**: The resources in the `bash` directory use Bash scripting for a simple method of deploying Bridge.
- **Ansible**: The resources in the `ansible` directory use Ansible to make the deployment of the Bridge client as hands off as possible.

### AWS ECS Service

Deploying Tableau Bridge using AWS ECS (Elastic Container Service) offers scalability and integration with AWS's cloud infrastructure. The resources in the `ecs` directory leverage Terraform to automate the provison of the resources required to get Bridge running in ECS. This is ideal for larger-scale environments where Tableau Cloud needs to connect to data in AWS that is not publically accessible.
