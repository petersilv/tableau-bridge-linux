# Centos 7 is the supported base image
FROM centos:7
RUN yum -y update

# Copy the bridge RPM package, install it, then remove it from the image
COPY bridge.rpm token ./
RUN ACCEPT_EULA=y yum install -y bridge.rpm && rm *.rpm

# Install Postgres Driver
COPY postgresql.jar /opt/tableau/tableau_driver/jdbc/

# Start bridge client on container launch
CMD /opt/tableau/tableau_bridge/bin/TabBridgeClientWorker \
    -e \
    --site="$SITE" \
    --client="$CLIENT" \
    --userEmail="$USEREMAIL" \
    --patTokenId="$PATTOKENID" \
    --patTokenFile="./token" \
    >> /root/Documents/My_Tableau_Bridge_Repository/Logs/bridge_start.log 2>&1
