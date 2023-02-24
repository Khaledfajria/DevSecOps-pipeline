# Use an official Python runtime as the base image
#FROM python:3.8-alpine

#ARG jenkins-nexus
# Set up environment variables
#ENV NEXUS_URL=http://172.174.163.230:8081/repository

# Set the working directory in the container
#WORKDIR /app
#RUN apk --no-cache add curl
# ADD http://172.174.163.230:8081/repository/Djecommerce-artifact/repository/Djecommerce-artifact/zed/com/Django-ecommerce/1.1.256/Django-ecommerce-1.1.256-package.tar.gz /app/
# Retrieve the zip file from Nexus
#RUN mkdir app
#RUN wget http://css:css@172.174.163.230:8081/repository/Djecommerce-artifact/repository/Djecommerce-artifact/zed/com/Django-ecommerce/1.1.276/Django-ecommerce-1.1.276-file.tar.gz
#RUN pwd && ls
# ADD $NEXUS_URL/Djecommerce-artifact/Django-ecommerce-*.tar.gz /app/
# Copy the source distribution archive to the container
# COPY dist/Django-ecommerce-*.tar.gz /app/

# Extract the source distribution archive and install the package
#RUN tar -xzf Django-ecommerce-*.tar.gz --strip-components=1 && \
#    pip install .

# Run the command to start the Django development server
# CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
# -------------------------------------------------------------------------------
FROM python:3.8-alpine

ENV NEXUS_URL=http://20.163.172.235:8081/repository
ENV REPO_NAME=Djecommerce-artifact
ENV GROUP_ID=zed
ENV ARTIFACT_ID=Django-ecommerce

WORKDIR /app

# Install curl
RUN apk --no-cache add curl

# Fetch the latest version of the artifact from Nexus using the REST API
RUN export ARTIFACT_VERSION=$(curl --silent "${NEXUS_URL}/${REPO_NAME}/service/rest/v1/search/assets?group=${GROUP_ID}&name=${ARTIFACT_ID}&sort=version&direction=desc" | jq -r '.items[0].version')
RUN echo "Fetching artifact version: ${ARTIFACT_VERSION}"
RUN curl --fail --silent -o Django-ecommerce-*.tar.gz -u "${NEXUS_USERNAME}:${NEXUS_PASSWORD}" "${NEXUS_URL}/${REPO_NAME}/${GROUP_ID}/$(echo ${ARTIFACT_ID} | tr '-' '/')/${ARTIFACT_VERSION}/${ARTIFACT_ID}-${ARTIFACT_VERSION}-file.tar.gz"

# Extract the artifact and install dependencies
RUN tar -xzf Django-ecommerce-*.tar.gz --strip-components=1 && \
    pip install .

# Start the application
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]