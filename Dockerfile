FROM python:3.12.3-slim
# it should be slim because it is much faster than other tags.
# for now, I do not install the latest version because it may be different from the version I've worked with.

LABEL maintainer="Setayesh"
# here I define the person who will be maintaining this project.

ENV PYTHONUNBUFFERED=1
# so buffer is a thing in Python — it keeps a number of outputs and then shows them all together.
# here we tell Python to stop using that and show us our logs immediately.

COPY ./requirements.txt /tmp/requirements.txt
# here we tell Docker to copy requirements.txt into the Docker image (to a temporary folder for installation).
COPY ./requirements.dev.txt /tmp/requirements.dev.txt
COPY ./app /app
# it is going to copy the directory of our app into the Docker container.

WORKDIR /app
# this is our main working directory, the place where we run our commands from inside the container.

EXPOSE 8000

ARG DEV=false 
# this is the port that Docker is going to expose for this container — and that's how we're going to connect to the Django server.
RUN apt-get update && apt-get install -y \
    python3-venv \
    gcc \
    libpq-dev \
    build-essential \
    && rm -rf /var/lib/apt/lists/*
# below we have the RUN command which is going to install some dependencies:
RUN python -m venv /py && \
    /py/bin/pip install --upgrade pip && \
    /py/bin/pip install -r /tmp/requirements.txt && \
    rm -rf /tmp/requirements.txt && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user


ENV PATH="/py/bin:$PATH"


USER django-user

# line 25 => we create a virtual environment inside our container.
# because inside a container, Python may point to a system-level Python (like Ubuntu’s).
# in this case, installing with pip directly can cause conflicts with system tools.

# line 26 => here instead of using the system pip, we upgrade and install pip inside the virtual environment.

# line 27 => we install all Python dependencies listed in requirements.txt into the virtual environment.

# line 28 => we remove the temporary file to keep the image clean and small.

# lines 29–32 => here we create a limited non-root user.
# this improves security, so when an attacker tries to connect to the container,
# they won't be running as root and will face more restrictions.


# line 35 => we set the path to make sure Python and pip commands point to the virtual environment.

#36=> we run the container as the limited user we just created.
