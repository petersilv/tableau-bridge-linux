# Tableau Bridge for AWS ECS - Instance

This part of the repository provides the resources required to deploy Tableau Bridge on an AWS ECS instance using Terraform.

## Prerequisites

Before proceeding with the deployment, ensure that you meet the following requirements:

1. **Terraform**:
    - Terraform is installed on your local machine. The required version is `>= 1.3.9`.
    - The AWS provider for Terraform is installed with version `>= 4.55.0`.

2. **AWS**:
    - You have an AWS account and have configured your AWS credentials on your local machine.
    - You have the necessary permissions to create and manage AWS resources.

3. **Docker**:
    - Docker is installed on your local machine.

4. **GitHub**:
    - You have git installed to clone repositories.

5. **Tableau Cloud**:
    - There is a personal access token for a Site Admin user ready to be associated with the Bridge Client.

## Deployment Instructions

1. **Clone the Repository**:
    Clone this GitHub repository to your local machine:

    ```bash
    git clone https://github.com/petersilv/tableau-bridge-linux.git
    ```

2. **Configuration**:
    - Update the `variables.json` file in the `ecs/resources` directory with the appropriate values for your Tableau Cloud setup.
    - Create a `terraform.tfvars` file in the `ecs/terraform` directory with the appropriate values for the `variables.tf` variables that correspond to your AWS setup.

3. **Deploy with Terraform**:

    Navigate to the `ecs/terraform` directory in the cloned repository and initialize Terraform:

    ```bash
    terraform init
    ```

    Then apply the Terraform configuration:

    ```bash
    terraform apply
    ```

    An ECS service will start desired task count of 1 but that task will not run successfully until the next steps have been completed.

4. **Build and Push Docker Image**:

    Navigate to the `ecs/scripts` directory in the cloned repository and run the `push_image.sh` script. This will build the Docker image and push it to your AWS ECR repository.

    ```bash
    ./push_image.sh
    ```

5. **Upload Secrets to AWS Secrets Manager**:

    Run the `put_secret_values.sh` script. This will upload the values from your `variables.json` file to AWS Secrets Manager.

    ```bash
    ./put_secret_values.shsh
    ```

Once the above steps have been completed, after a few minutes a task should have provisioned successfully and a Tableau Bridge client will be deployed in the target AWS ECS service.
