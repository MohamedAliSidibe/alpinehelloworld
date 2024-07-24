# Grab the latest alpine image
FROM alpine:latest

# Install dependencies and create a virtual environment
RUN apk add --no-cache --update python3 py3-pip bash \
    && python3 -m venv /venv \
    && /venv/bin/pip install --upgrade pip

# Add the requirements file
ADD ./webapp/requirements.txt /tmp/requirements.txt

# Set environment variables
ENV PATH="/venv/bin:$PATH"

# Install dependencies inside the virtual environment
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Add our code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Run the image as a non-root user
RUN adduser -D myuser
USER myuser

# Run the app
CMD gunicorn --bind 0.0.0.0:$PORT wsgi
