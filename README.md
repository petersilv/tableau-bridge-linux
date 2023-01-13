# Tableau Bridge on Linux

## Instructions

1. Remote into the instance that the Bridge container will run on.
2. Download the contents of this GitHub repository `git clone https://github.com/petersilv/tableau-bridge-linux.git`.
3. Update the `token` and `variables` files with values from your own Tableau Cloud site.
4. Download the Bridge installer to the directory that contains the `deploy.sh` file.
5. Download any required drivers to the directory that contains the `deploy.sh` file. This example requires the postgres driver by default, if you want to remove this or add others you will need to update the Dockerfile accordingly.
6. Run the `deploy.sh` script.
