# Tableau Bridge for Linux

This provides the resources required to deploy the Tableau Bridge on a Linux machine using Ansible.

## Prerequisites

Before proceeding with the deployment, ensure that you meet the following requirements:

1. **Ansible**:
    - Ansible is installed on the controlling machine.
    - The Docker Community Collection for Ansible is installed [(link)](https://galaxy.ansible.com/ui/repo/published/community/docker).
    - The Ansible role `geerlingguy.docker` is installed [(link)](https://galaxy.ansible.com/ui/standalone/roles/geerlingguy/docker/).

2. **Remote Machine Access**:
    - You have SSH access to the target machine where the Tableau Bridge will be deployed.

3. **GitHub**:
    - You have `git` installed to clone repositories.

4. **Tableau Cloud**:
    - There is a personal access token for a Site Admin user ready to be associated with the Bridge Client

## Deployment Instructions

1. **Clone the Repository**:

    Clone this GitHub repository to your local machine:

    ```bash
    git clone https://github.com/petersilv/tableau-bridge-linux.git
    ```

2. **Configuration**:
    - Update the `token` file with the required access token from your Tableau Cloud site.
    - Update the `variables` file to reflect the appropriate values corresponding to your Tableau Cloud setup.
    - Update the `inventory.yaml` file with the details for the target machine where the Tableau Bridge will be deployed.

3. **Optional Additional Drivers**

    This repository has been configured to install only the Postgres driver to the Bridge container. If you need additional drivers then update the ansible playbook and Dockerfile accordingly.

4. **Deploy with Ansible**:

    Navigate to the `bridge` directory in the cloned repository and deploy the Ansible playbook. Ensure you are pointing to the correct inventory and playbook file:

    ```bash
    ansible-playbook -i inventory.yaml main.yml
    ```

Once the playbook run completes successfully, Tableau Bridge should be deployed and configured on the target Linux machine.
