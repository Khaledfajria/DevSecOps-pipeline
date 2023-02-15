# Use an official Python runtime as the base image
FROM python:3.8-alpine

# Set the working directory in the container
WORKDIR /app

# Copy the code to the container
COPY . .
COPY .env /app/

# Upgrade pip
RUN python -m pip install --upgrade pip
RUN pip install virtualenv
RUN virtualenv env
RUN source env/bin/activate
# Install the dependencies
RUN pip install -r requirements.txt
# Set the environment variables
ENV DJANGO_SETTINGS_MODULE=djecommerce.settings.development
ENV SECRET_KEY='kobl@t=yw9d*0y%jt2gjnq78=u!z_rrxb&w8e47l!(jz@m79zy'
# Run the command to start the Django development server
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
