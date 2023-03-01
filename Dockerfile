# Use an official Python runtime as the base image
FROM python:3.10-alpine

# Adds a new group and user

RUN addgroup -S devsecops && adduser -S django -G devsecops

# Set the working directory in the container
WORKDIR /home/app

# Copy the source distribution archive to the container
COPY dist/Django-ecommerce-*.tar.gz /home/app/

# Extract the source distribution archive and install the package
RUN tar -xzf Django-ecommerce-*.tar.gz --strip-components=1 && \
    pip install . \

#Switch to django user
USER django

# Run the command to start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]