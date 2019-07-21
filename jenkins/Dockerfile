FROM jenkins/jenkins:2.176.1-alpine

#Install openssl for helm
RUN apk add --update openssl

# For kubernetes permission errors
USER root

VOLUME [ "/var/jenkins_home" ]

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

# for main web interface:
EXPOSE 8080 

# will be used by attached slave agents:
EXPOSE 50001
