## Index

  Generate/Build Rails Application


---

## Generate/Build Rails Application

### Building Dockerfile

What Ruby images does Docker support? https://hub.docker.com/_/ruby

Dockerfile

```text
FROM ruby:3.2.2
LABEL maintainer="Chris Arndt <my_email_address@yahoo.com>"

# Download latest package information and install packages.
# -y option says to answer yes to any prompts.
# -qq option enables quiet mode to reduce printed output.
# Note: it is always recommended to combine the apt-get update and
#       apt-get install commands into a single RUN instruction.
# apt-transport-https = allow apt to work with https-based sources
# RUN apt-get update -yqq
# rm -rf /var/lib/apt/lists/* == removes nodejs package lists.
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get update -y && apt-get --force-yes install -y --no-install-recommends  \
    build-essential \
    vim \
    curl \
    less \
    libmariadb-dev \
    git \
    nodejs && \
    rm -rf /var/lib/apt/lists/*

# Install Yarn globally
RUN npm install --global yarn

# Make this the current working directory for the image. So we can execute Rails \
# cmds against image.
RUN mkdir -p /usr/src/app

# Gemfile Caching Trick
# Note: When using COPY with more than one source file, the destination must
#       be a directory and end with a /
# 1. This creates a separate, independent layer. Docker's cache for this layer
#    will only be busted if either of these two files (Gemfile & Gemfile.lcok) change.
#COPY Gemfile* /usr/src/app/

# CD or change into the working directory.
WORKDIR /usr/src/app

```

### Create docker-compose.yml file and fill in with

```text
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    # A volume is set up that mounts the current path of the host machine to
    # the folder /usr/src/app in the container.
    # The volume is essential so that when we generate the Rails application in
    # the container, the template files will persist in the host filesystem.
    volumes:
      - .:/usr/src/app
    ports:
      - "3000:3000"

```

### Generate Rails Application

```text
$ docker compose run --service-ports app bash
    * If you do want the service’s ports to be created and mapped to the host, specify the --service-ports

Once inside the container, we can install Rails and generate a new application
$ gem install rails

# Generates new Rails application with a name and add files to the location specified.
root@c430440b3179:/usr/src/app# rails new cals_forms -j=esbuild -d=mysql --skip-test --css=bootstrap

# Copy the contents from within "cals_forms" to "/usr/src/app/"
$ cp -a /usr/src/app/cals_forms/. /usr/src/app/
    * The -a option is an improved recursive option, that preserve all file attributes, and also preserve symlinks.
    * The . at end of the source path is a specific cp syntax that allow to copy all files and folders, included hidden ones.

# Remove the auto-generated directory.
rm -rf /usr/src/app/cals_forms

# Should be able to start the application at this point and visit it via browser.
# And did receive an error both in console and in browser about not being able to connect to MySQL.
root@c430440b3179:/usr/src/app# rails s -b 0.0.0.0

root@c430440b3179:/usr/src/app# exit

# Will need to apply directory and file permissions
$ sudo chown -R $USER:$USER .

```


