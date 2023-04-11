Description

  * Set up on Ubuntu 22.04 LTS server.

## Index

  Don't need to pass a password for sudo commands
  
  Set / Change Timezone on Server
  
  Add Apache PPA to Ubuntu Server
  
  Install Apache2
  
  Install Docker Engine
  
  .

---

## Don't need to pass a password for sudo commands

```text
    Within /etc/sudoers.d/
    
    Create a new file with the name of user account (ex. scott).
        $ sudo vim scott
    
    And place the below within scott file.
        scott ALL=(ALL) NOPASSWD:ALL
```

## Set / Change Timezone on Server

    https://itslinuxfoss.com/set-change-timezone-ubuntu-22-04/

1) Check current timezone

    `$ timedatectl`

2) Get the list of Available Timezone
```text
    $ timedatectl list-timezones
     => America/Chicago
```

3) Set the region and Timezone according to your preferences

    `$ sudo timedatectl set-timezone America/Chicago`

4) Confirm Timezone Changes

    `$ cat /etc/timezone`

## Add Apache PPA to Ubuntu Server

```text
    https://ppa.launchpadcontent.net/ondrej/apache2/ubuntu/

    Website: https://launchpad.net/~ondrej/+archive/ubuntu/apache2
    
    Following the site in how to Add PPA to your system:
        $ sudo add-apt-repository ppa:ondrej/apache2
        $ sudo apt update
```

## Install Apache2

```text
    1) https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-22-04
    
    2) $ sudo apt install apache2
    
    3) Check to see if apache2 process is running
    
        $ sudo service apache2 status

    4) Check to see if Apache2 default html page displays
    
        Browser: http://scott.cals.wisc.edu/
```

## Install Docker Engine

```text
Resources
  * https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04

$ sudo apt update

Install a few prerequisite packages which let apt use packages over HTTPS
$ sudo apt install apt-transport-https ca-certificates curl software-properties-common

Add the GPG key for the official Docker repository to your system
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

Add the Docker repository to APT sources
$ echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

Update your existing list of packages again for the addition to be recognized
$ sudo apt update

Make sure you are about to install from the Docker repo instead of the default Ubuntu repo
$ apt-cache policy docker-ce

Finally, install Docker
$ sudo apt install docker-ce

Docker should now be installed, the daemon started, and the process enabled to start on boot. Check that it’s running
$ sudo systemctl status docker
or
$ sudo service docker status
Note: Installing Docker now gives you not just the Docker service (daemon) but also the docker command line utility, or the Docker client.

Executing the Docker Command Without Sudo
$ sudo usermod -aG docker ${USER}
Note: To apply the new group membership, log out of the server and back in.

Confirm that your user is now added to the docker group by typing
$ groups

In using "docker image build" commands I get the below message:
    DEPRECATED: The legacy builder is deprecated and will be removed in a future release.
                Install the buildx component to build images with BuildKit:
                https://docs.docker.com/go/buildx/

So to address this message and install buildx plugin:
$ sudo apt install docker-buildx-plugin

Set "docker build" command as an alias to "docker buildx"
$ docker buildx install

```



