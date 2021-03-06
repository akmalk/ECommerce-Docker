#!/bin/bash

# Set correct variables

source /env.sh

# Configure analytics-agent.properties

aaprop=/machine_agent/monitors/analytics-agent/conf/analytics-agent.properties

if [ "$(grep '^http.event.endpoint=http://localhost:9080/v1' $aaprop)" ]; then
        echo "${aaprop}: setting correct endpoint"
	sed -i "/^http.event.endpoint=/c\http.event.endpoint=http:\/\/${EUM_CLOUD}:9080\/v1" ${aaprop}
else
        echo "${aaprop}: endpoint already set or doesn't exist"
fi

if [ "$(grep '^http.event.accountName=analytics-customer1$' $aaprop)" ]; then
        echo "${aaprop}: setting correct account name"
	sed -i "/^http.event.accountName=/c\http.event.accountName=${ACCOUNT_NAME}" ${aaprop}
else
        echo "${aaprop}: account name already set or doesn't exist"
fi

if [ "$(grep '^http.event.accessKey=your-account-access-key$' $aaprop)" ]; then
        echo "${aaprop}: setting correct accessKey"
        sed -i "/^http.event.accessKey=/c\http.event.accessKey=${ACCESS_KEY}" ${aaprop}
else
        echo "${aaprop}: accessKey already set or doesn't exist"
fi

# Configure monitor.xml

monxml=/machine_agent/monitors/analytics-agent/monitor.xml

if [ "$(grep '<enabled>false</enabled>' $monxml)" ]; then
        echo "${monxml}: setting to "true""
	sed -i 's#<enabled>false</enabled>#<enabled>true</enabled>#g' ${monxml}
else
        echo "${monxml}: already enabled or doesn't exist"
fi

# Configure sample-java-agent-log.job

sjal=/machine_agent/monitors/analytics-agent/conf/job/sample-java-agent-log.job

if [ "$(grep '^enabled: false' $sjal)" ]; then
        echo "${sjal}: setting to "true""
	sed -i '/^enabled/c\enabled: true' ${sjal}
else
        echo "${sjal}: already enabled or doesn't exist"
fi

if [ "$(grep 'path: \$' $sjal)" ]; then
        echo "${sjal}: setting to correct path"
        sed -i "/path:/c\    path: /tomcat/appagent/${VERSION_STRING}/logs/${NODE_NAME}" ${sjal}
else
        echo "${sjal}: path already set or doesn't exist"
fi

# Restart the Machine Agent

echo "killing MachineAgent"
echo `ps -ef | grep machineagent.jar | grep -v grep | awk '{print $2}'`
kill -9 `ps -ef | grep machineagent.jar | grep -v grep | awk '{print $2}'`
/start-machine-agent.sh

exit 0
