# Tableau Bridge for Linux - Bash

Deploy Tableau Bridge on a Linux machine using Bash scripting.

## Prerequisites

Before proceeding with the deployment, ensure that you meet the following requirements:

1. **Remote Machine Access**:
    - You have SSH access to the target machine where the Tableau Bridge will be deployed.

2. **Git**:
    - You have `git` installed to clone repositories.

3. **Tableau Cloud**:
    - There is a personal access token for a Site Admin user ready to be associated with the Bridge Client

## Deployment Instructions

1. **Clone the Repository**:

    Clone this GitHub repository to your local machine:

    ```bash
    git clone https://github.com/petersilv/tableau-bridge-linux.git
    ```

2. **Configuration**:

    Update the `bash/variables.sh` file to reflect the appropriate values corresponding to your Tableau Cloud setup.

3. **Optional Additional Drivers**:

    This repository has been configured to install only the Postgres driver to the Bridge container. If you need additional drivers then update the Dockerfile and variables.sh accordingly.

4. **Copy files to the Bridge Instance**:

    Copy the necessary files from the `bash` directory to the target machine where Tableau Bridge will be deployed. For example, you can use `scp` command to securely copy files over SSH:

    ```bash
    scp ./bash/* username@remote:/path/to/destination
    ```

5. **SSH into the Bridge Instance and Run the Deploy Script**:

    SSH into the target machine where Tableau Bridge will be deployed using the following command:

    ```bash
    ssh username@remote
    ```

    Once you are logged into the machine, navigate to the directory where the deploy script is located and run it to launch the Tableau Bridge container:

    ```bash
    cd /path/to/destination
    ./deploy.sh
    ```

    The deploy script will handle the necessary steps to deploy and configure Tableau Bridge on the Linux machine.
