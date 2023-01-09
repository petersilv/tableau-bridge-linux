# Centos 7 is the supported base image
FROM centos:7
RUN yum -y update

# Copy the bridge RPM package, install it, then remove it from the image
COPY bridge.rpm token variables ./
RUN ACCEPT_EULA=y yum install -y bridge.rpm && rm *.rpm

# Install Postgres Driver
COPY postgresql-42.3.3.jar /opt/tableau/tableau_driver/jdbc/
