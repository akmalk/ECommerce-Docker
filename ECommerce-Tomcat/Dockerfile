FROM appdynamics/ecommerce-java:oracle-java7

# Install Gradle
RUN wget -N http://services.gradle.org/distributions/gradle-2.1-bin.zip
RUN unzip gradle-2.1-bin.zip -d /opt/
RUN rm gradle-2.1-bin.zip
ENV GRADLE_HOME /opt/gradle-2.1
ENV PATH $PATH:$GRADLE_HOME/bin

# Git Checkout
RUN git clone https://github.com/Appdynamics/ECommerce-Java.git

# Gradle build
RUN cd /ECommerce-Java;gradle war uberJar;

# Environment vars: Tomcat
ENV TOMCAT_MAJOR_VERSION 8
ENV TOMCAT_MINOR_VERSION 8.0.14
ENV CATALINA_HOME /tomcat

# Install Tomcat
RUN wget -q https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz && \
    wget -qO- https://archive.apache.org/dist/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.md5 | md5sum -c - && \
    tar zxf apache-tomcat-*.tar.gz && \
    rm apache-tomcat-*.tar.gz && \
    mv apache-tomcat* tomcat

RUN cd ${CATALINA_HOME}/bin;chmod +x *.sh

# App Server Agent Install
ADD AppServerAgent.zip /
RUN unzip /AppServerAgent.zip -d ${CATALINA_HOME}/appagent
RUN rm AppServerAgent.zip

# Machine Agent Install
ENV MACHINE_AGENT_HOME /machine_agent
ADD MachineAgent.zip /
RUN unzip /MachineAgent.zip -d ${MACHINE_AGENT_HOME}
RUN rm MachineAgent.zip

# Machine Agent scripts for Run Book Automation
ADD increase-pool.sh ${MACHINE_AGENT_HOME}/local-scripts/
ADD shrink-pool.sh ${MACHINE_AGENT_HOME}/local-scripts/
RUN chmod +x ${MACHINE_AGENT_HOME}/local-scripts/*.sh

# Analytics Agent config
ADD configAnalytics.sh /
RUN chmod +x /configAnalytics.sh

# Startup scripts
ADD startup.sh /
ADD env.sh /
RUN version=`find ${CATALINA_HOME}/appagent -type d -name "ver*" | sed "s:^${CATALINA_HOME}/appagent/::"`; \
    sed -e "s:_VERSION_STRING:$version:g" env.sh > env.sh.tmp && mv env.sh.tmp env.sh
ADD start-machine-agent.sh /

RUN chmod +x /startup.sh
RUN chmod +x /start-machine-agent.sh
RUN chmod +x /env.sh
WORKDIR /
CMD ["/bin/bash","/startup.sh"]

EXPOSE 80	
EXPOSE 8080
EXPOSE 8009
