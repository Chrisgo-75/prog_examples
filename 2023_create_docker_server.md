Description

  * Set up on Ubuntu 22.04 LTS server.

## Index

  Don't need to pass a password for sudo commands
  
  Set / Change Timezone on Server
  
  Add Apache PPA to Ubuntu Server
  
  Install Apache2
  
  Install Docker Engine
  
  Set Up Lets Encrypt and Enable SSL on Apache2
  
  Install and Set up Shibboleth
  
  Apache Commands

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

## Set Up Lets Encrypt and Enable SSL on Apache2

```text
Resources
  * https://www.digitalocean.com/community/tutorials/how-to-secure-apache-with-let-s-encrypt-on-ubuntu-20-04
  * https://certbot.eff.org/
  * https://certbot.eff.org/instructions?ws=apache&os=ubuntufocal

1) enable ssl using the following command
    $ sudo a2enmod ssl
    
    $ sudo service apache2 restart

2) To test that snapd is installed on your system, install the hello-world snap and make sure it runs correctly:

    $ sudo snap install hello-world
    hello-world 6.4 from Canonical✓ installed
    $ hello-world
    Hello World!

3) Execute the following instructions on the command line on the machine to ensure that you have the latest version of snapd.

    $ sudo snap install core; sudo snap refresh core

4) Remove certbot-auto and any Certbot OS packages
    
    $ sudo apt remove certbot

5) Install Certbot

    $ sudo snap install --classic certbot

6) Prepare the Certbot command
    Execute the following instruction on the command line on the machine to ensure that the certbot command can be run.

    $ sudo ln -s /snap/bin/certbot /usr/bin/certbot

7) Run this command to get a certificate and have Certbot edit your apache configuration automatically to serve it, turning on HTTPS access in a single step.

    $ sudo certbot --apache

    Please enter domain name: scott.cals.wisc.edu

```

## Install and Set up Shibboleth

```text
Resources
  * NetID Login Service - Apache Installation (Ubuntu / Debian) from Packages
      https://kb.wisc.edu/22747
  * NetID Login Service - Getting Started
      https://kb.wisc.edu/86317
  * https://medium.com/@winma.15/shibboleth-sp-installation-in-ubuntu-d284b8d850da
  * https://ws.learn.ac.lk/wiki/spiam2018

1) Install the Shibboleth SP:

    $ sudo apt install libapache2-mod-shib

2) Execute these commands to activate shibd on startup

    $ sudo chmod +x /etc/init.d/shibd
    $ sudo update-rc.d shibd defaults
    # At this point the Shibboleth daemon has been installed and configured to run at startup.

3) Start the Shibboleth daemon and examine the logs for any errors

    $ sudo service shibd start
    $ grep -E 'CRIT|ERROR' /var/log/shibboleth/shibd.log

    # You may see the following item in the shibd log. You can safely ignore it for now. 
    2016-01-20 09:31:20 CRIT Shibboleth.Application : no MetadataProvider available, configuration is probably unusable

    # You may also see one or both of the following errors indicating that your Shibboleth key pair is missing.
    ERROR OpenSSL : error data: fopen('/etc/shibboleth/sp-key.pem','r')
    CRIT Shibboleth.Application : error building CredentialResolver: Unable to load private key from file (/etc/shibboleth/sp-key.pem)
    
    # If the above error is in the log, run the following commands to install the key/cert files, and restart the Shibboleth service. 
    (Create SP metadata Signing and Encryption credentials)
    $ cd /etc/shibboleth


    # What I used:
    $ sudo shib-keygen -n sp-signing-new
    $ sudo shib-keygen -n sp-encrypt
    $ sudo openssl req -x509 -sha256 -nodes -days 3650 -newkey rsa:2048 -subj "/CN=$HOSTNAME" -keyout /etc/shibboleth/sp-signing-key.pem -out /etc/shibboleth/sp-signing-cert.pem
    # Note: make sure the two files that the above line creates is owned and grouped by "_shibd".
        $ sudo chown _shibd:_shibd sp-signing-cert.pem
        $ sudo chown _shibd:_shibd sp-signing-key.pem
    # Note: so these key/certs that are created is used to identify the host where Shibboleth is running. It is not connected to the websites that are running on it.

    # Example from the internet (which I did not use):
    $ shib-keygen -u _shibd -g _shibd -h scott.cals.wisc.edu -y 30 -e https://scott.cals.wisc.edu/shibboleth -n sp-signing -f
    $ shib-keygen -u _shibd -g _shibd -h scott.cals.wisc.edu -y 30 -e https://scott.cals.wisc.edu/shibboleth -n sp-encrypt -f

    $ sudo service shibd restart
    $ /usr/sbin/shibd -t
    $ sudo service shibd restart
    
    # Enable the shib2 module in Apache and restart Apache
    $ sudo a2enmod shib
    $ sudo service apache2 restart

    # Open up a web browser and point to your site with the following Shibboleth path
    https://www.yoursite.wisc.edu/Shibboleth.sso/Session
    https://scott.cals.wisc.edu/Shibboleth.sso/Session
        https://scott.cals.wisc.edu/Shibboleth.sso/Metadata
    # Verify that you see this message:
    A valid session was not found.

    # Generate Shibboleth2.xml File ... using https://kb.wisc.edu/22747
    a. Clicked on production link.
    b. Entered in values per web-form fields.
    c. Generated .xml file and placed in /etc/shibboleth/
    d. Edit Shibboleth2.xml
        Change entityID to your domain name. So:
        <ApplicationDefaults entityID="scott.cals.wisc.edu"

    # Download Metadata Signing Certificate
    a. Selected "production" ... actually ran below command on server.
    b. Placed file within /etc/shibboleth/
        $ sudo wget <look at kb.wisc.edu>

    # restart the Shibboleth daemon and Apache, examine the logs to verify that federation metadata was successfully downloaded
    $ sudo service shibd restart
    $ sudo service apache2 restart
    $ sudo grep extracted... /var/log/shibboleth/shibd.log
    # ... and the above command should output the following: (You should see the following in the shibd.log)
    2012-01-20 10:15:26 INFO OpenSAML.MetadataProvider.XML : loaded XML resource (extracted...)

    # Open up a web browser and point to your site with the following Shibboleth path:
    https://scott.cals.wisc.edu/Shibboleth.sso/Metadata
    # Verify that there is XML metadata content at this path, your browser may try to download it. 

    # Finally contact ******* to authorize https://scott.cals.wisc.edu as a valid service provider.

```

## Apache Commands

```text
/etc/apache2> $ cat ./sites-enabled/*
    * Displays config info and easier to see it grouped together.

$ apache2ctl -S
    * Shows warnings if there are any.
    * Shows virtual host configuration.

$ sudo apache2ctl configtest
$ apache2ctl -t
	* Checks Apache config files syntax.

$ apache2ctl -t -D DUMP_VHOSTS
	* Displays all virtual host configuration information.

# Other Commands

$ systemctl status apache2
	* displays status of apache server.

$ sudo service apache2 restart

$ systemctl [restart | reload] apache2
	* restarts apache server.

$ netstat -tupan | grep -i http
	* Lists the ports that the apache web server is listening on.

$ netstat -tupan | grep -i '80\|443'

$ apache2ctl -v
	* displays version of Apache server.
```
