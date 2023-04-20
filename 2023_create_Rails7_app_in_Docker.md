## Index

  Generate/Build Rails Application

  Final Dockerfile
  
  Final docker-compose.yml

  Further Setup
  
  keep sessions for 9 hrs only
  
  Running RSpec Tests
  
  Adding Custom SCSS
  
  Common Commands Used When Building Rails App

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

## Final Dockerfile

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
COPY Gemfile* /usr/src/app/

# CD or change into the working directory.
WORKDIR /usr/src/app

# Set timezone
ENV TZ=America/Chicago
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
#RUN timedatectl set-timezone America/Chicago

RUN bundle install

# ADD/COPY app files from local directory into container so they are baked into the image.
# The source path on our local machine is always relative to where the Dockerfile is located.
ADD . /usr/src/app

# Start the Rails server by default (bake it into the image).
#CMD ["rails", "s", "-b", "0.0.0.0"]
CMD ["bundle", "exec", "passenger", "start"]

```

## Final docker-compose.yml

```text
version: '3.8'

services:
  app:
    # build => tells Compose where to find the Dockerfile it should use
    #          to build our image. The path we specify is relative to
    #          the docker-compose.yml file.
    #          So builds an image for any service with a 'build' directive.
    build:
      context: .
      dockerfile: Dockerfile
    image: ex_app:latest
    container_name: ex_app_dev
    environment:
      # Represent WEBrick
      #PIDFILE: /tmp/pids/server.pid
      # Represent Passenger
      PIDFILE: /tmp/pids/passenger.3000.pid
      RAILS_ENV: development
      TZ: "America/Chicago"
    # A volume is set up that mounts the current path of the host machine to
    # the folder /usr/src/app in the container.
    # The volume is essential so that when we generate the Rails application in
    # the container, the template files will persist in the host filesystem.
    volumes:
      - .:/usr/src/app
    env_file:
      - app.env
    tmpfs:
      # tmpfs mount  is temporary and persists in the host memory.
      # When container stops, the tmpfs mount is removed, and all files in it will be gone.
      - /tmp/pids/
    ports:
      - "3000:3000"

```

## Further Setup

1) Add Phusion Passenger gem to Gemfile.

2) Runs `bundle install`: `$ docker compose up -d`

3) Add app.env   `$ touch app.env`

4) Copy in content to `.gitignore` file.

5) Copy in content to `.dockerignore` file.

6) git commit -a -m "initial commit"

7) Add secrets

```text
Populate app.env file with secrets.
And get secret token by going into rbenv application and running:
$ bundle exec rake secret
Or
$ docker exec -it cals_forms_dev bash
> bundle exec rails secret
```

8) Edit `/config/database.yml` file.

9) At the end of `/config/environments/development.rb` and `/config/environments/production.rb` and `/config/environments/staging.rb` add the below. And yes if `staging.rb` doesn't exist will need to copy `production.rb` and rename to `staging.rb`

```text
# Rails server 'missing secret_key_base':
# This has been added by developer b/c on the Rails servers, Rails app isn't grabbing
# 'secret_key_base' from Rails server Env successfully. So ended up manually helping
# Rails!
# config.secret_key_base = ENV['secret_key_base']
# Instead of using Figaro gem, have removed it and am assigning value within application.
config.secret_key_base = ENV.fetch('secret_key_base')

```

10) Start up application see if it runs.

## keep sessions for 9 hrs only

1) New file: `config/initializers/session_store.rb`

2) Content within file

```text
Rails.application.config.session_store :cookie_store,
                                       key: '_exapp_session',
                                       same_site: :lax,
                                       expire_after: 9.hours
```

## Running RSpec Tests

```text
Run tests from a file only:
    $ docker compose run --rm -e "RAILS_ENV=test" app bundle exec rspec spec/models/station_spec.rb

Run all rspec tests
    $ docker compose run --rm -e "RAILS_ENV=test" app bundle exec rspec spec

Run a specific test 
    $ docker compose run --rm -e "RAILS_ENV=test" app bundle exec rspec spec/models/station_spec.rb:19
```

## Adding Custom SCSS

### Bundling CSS Into One Big File

1) Created new SCSS file within `app/assets/stylesheets/arspirf_site.scss`

2) Link to new SCSS file within `app/assets/stylesheets/application.bootstrap.scss`

```text
    @import 'arspirf_site';
```

3) Run `yarn run build:css` to recompile the CSS assets

```text
    Docker container is running.
    $ docker exec -it ex_app_dev bash
    # yarn run build:css
    # exit
    I then opened browser and verified changes took effect which they did.
    FYI: the custom CSS was added to a single compiled CSS file. I viewed the CSS file in browser on dev.
```

4) Notes/resources

  * https://github.com/rails/cssbundling-rails

  * https://github.com/rails/jsbundling-rails

  * https://www.nickhammond.com/learning-to-love-bin-slash-dev-in-rails-7/

### Bundle CSS Into Separate Files (wasn't able to get this to work)

1) Created new scss file within `app/assets/stylesheets/arspirf_site.scss`

2) Link to new CSS/SCSS files within application.html.erb

```text
    # You can refer to other CSS files by ***expanding*** the stylesheet_link_tag in application.html.erb like so:
    <%= stylesheet_link_tag "application", "other", "styles", "data-turbo-track": "reload" %>
```

## Common Commands Used When Building Rails App

1) Generating Files via Rails, will need to re-apply folder/file permissions

```text
    $ sudo chown -R $USER:$USER .
```

