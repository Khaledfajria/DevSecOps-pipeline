# Use an official Python runtime as the base image
FROM python:3.8-alpine

# Set up environment variables
ENV NEXUS_URL=http://172.174.163.230:8081/repository

# Set the working directory in the container
WORKDIR /app
RUN apk --no-cache add curl
# ADD http://172.174.163.230:8081/repository/Djecommerce-artifact/repository/Djecommerce-artifact/zed/com/Django-ecommerce/1.1.256/Django-ecommerce-1.1.256-package.tar.gz /app/
# Retrieve the zip file from Nexus
RUN curl -O http://172.174.163.230:8081/repository/Djecommerce-artifact/zed/com/Django-ecommerce/1.1.256/Django-ecommerce-1.1.256-package.tar.gz /app/
# ADD $NEXUS_URL/Djecommerce-artifact/Django-ecommerce-*.tar.gz /app/
# Copy the source distribution archive to the container
# COPY dist/Django-ecommerce-*.tar.gz /app/

# Extract the source distribution archive and install the package
RUN tar -xzf tar -xzf Django-ecommerce-*.tar.gz --strip-components=1 && \
    pip install .

# Run the command to start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
