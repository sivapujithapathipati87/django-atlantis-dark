# Use an official Python runtime as a parent image
FROM python:3.8-alpine

# Set environment variables for Python and Docker
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1

# Set up dependencies
RUN apk update && \
    apk add --virtual build-deps gcc python3-dev musl-dev && \
    apk add postgresql-dev gettext

# Set the working directory in the container
WORKDIR /code

# Copy the current directory contents into the container at /code
COPY . /code/

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Set up database
RUN python manage.py makemigrations
RUN python manage.py migrate

# Create superuser
RUN python manage.py createsuperuser --noinput \
    --username admin \
    --email admin@example.com

# Expose the port that the Django app runs on
EXPOSE 8000

# Run the Django app
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]
