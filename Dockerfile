# Build environment
FROM python:3.10-alpine AS builder

# Adds a new group and user
RUN addgroup -S devsecops && adduser -S django -G devsecops

# Set the working directory in the container
WORKDIR /home/app

# Copy the source distribution archive to the container
COPY dist/Django-ecommerce-*.tar.gz /home/app/

# Extract the source distribution archive and install the package
RUN tar -xzf Django-ecommerce-*.tar.gz --strip-components=1 && \
    pip install .

# Runtime environment
FROM python:3.10-alpine AS runtime

# Adds a new group and user
RUN addgroup -S devsecops && adduser -S django -G devsecops

# Set the working directory in the container
WORKDIR /home/app

# Copy the installed package from the builder container
COPY --from=builder /usr/local/lib/python3.10/site-packages /usr/local/lib/python3.10/site-packages
COPY --from=builder /home/app /home/app
#Switch to django user
USER django

# Run the command to start the Django development server
CMD ["python", "/home/app/manage.py", "runserver", "0.0.0.0:8000"]