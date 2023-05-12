FROM openjdk:11-jdk
WORKDIR /var/jenkins_home/workspace/Backend/BackEnd/SOA

COPY build/libs/coursemores-0.0.1-SNAPSHOT.jar /app.jar
COPY apm/elastic-apm-agent-1.18.0.jar /apm-agent.jar

EXPOSE 8081

ENTRYPOINT ["java", \
"-javaagent:/apm-agent.jar", \
"-Delastic.apm.server_urls=http://coursemores.site:8200", \
"-Delastic.apm.service_name=coursemores", \
"-Delastic.apm.application_packages=com.moham.coursemores", \
"-Delastic.apm.environment=dev", \
"-Dspring.profiles.active=dev", \
"-jar", \
"/app.jar"]





