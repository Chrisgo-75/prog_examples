Description

  * Set up on Ubuntu 22.04 LTS server.

## Index

  Don't need to pass a password for sudo commands
  
  Set / Change Timezone on Server
  
  Add Apache PPA to Ubuntu Server
  
  Install Apache2
  
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


