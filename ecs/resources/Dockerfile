# Centos 7 is the supported base image
FROM centos:7
RUN yum -y update && \
    yum -y install unzip wget epel-release && \
    yum -y install jq

# Define variables
ARG AWS_CLI_INSTALLER="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
ARG BRIDGE_INSTALLER="https://downloads.tableau.com/tssoftware/TableauBridge-20233.23.1017.0948.x86_64.rpm"
ARG POSTGRES_DRIVER="https://jdbc.postgresql.org/download/postgresql-42.6.0.jar"

# Download and install the AWS CLI
RUN wget -O awscliv2.zip "$AWS_CLI_INSTALLER" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip ./aws

# Download and install the Bridge RPM package
RUN wget -O bridge.rpm "$BRIDGE_INSTALLER" && \
    ACCEPT_EULA=y yum install -y bridge.rpm && \
    rm bridge.rpm

# Install Postgres Driver
RUN wget -O postgresql.jar "$POSTGRES_DRIVER" && \
    mkdir -p /opt/tableau/tableau_driver/jdbc/ && \
    mv postgresql.jar /opt/tableau/tableau_driver/jdbc/

# Copy the get variables script
COPY get-variables /
