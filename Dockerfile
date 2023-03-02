# Use an official Python runtime as the base image
FROM python:3.10-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the source distribution archive to the container
COPY dist/Django-ecommerce-*.tar.gz /app/

# Extract the source distribution archive and install the package
RUN tar -xzf tar -xzf Django-ecommerce-*.tar.gz --strip-components=1 && \
    pip install .

# Run the command to start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
