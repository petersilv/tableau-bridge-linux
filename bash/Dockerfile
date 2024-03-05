# Centos 7 is the supported base image
FROM centos:7
RUN yum -y update && \
    yum -y upgrade && \
    yum -y install wget

# Define arguments
ARG BRIDGE_INSTALLER="https://downloads.tableau.com/tssoftware/TableauBridge-20241.24.0208.0337.x86_64.rpm"
ARG POSTGRES_DRIVER="https://jdbc.postgresql.org/download/postgresql-42.7.2.jar"

# Download and install the Bridge RPM package
RUN wget -O bridge.rpm "$BRIDGE_INSTALLER" && \
    ACCEPT_EULA=y yum install -y bridge.rpm && \
    rm bridge.rpm

# Install Postgres Driver
RUN wget -O postgresql.jar "$POSTGRES_DRIVER" && \
    mkdir -p /opt/tableau/tableau_driver/jdbc/ && \
    mv postgresql.jar /opt/tableau/tableau_driver/jdbc/

# Start bridge client on container launch
CMD echo "{$TOKEN_ID:$TOKEN_SECRET}" > /tmp/token && chmod 600 /tmp/token && \
    /opt/tableau/tableau_bridge/bin/TabBridgeClientWorker \
        -e \
        --site="$SITE" \
        --client="$CLIENT" \
        --userEmail="$USER_EMAIL" \
        --patTokenId="$TOKEN_ID" \
        --patTokenFile="/tmp/token" \
        >> /root/Documents/My_Tableau_Bridge_Repository/Logs/bridge_start.log 2>&1
