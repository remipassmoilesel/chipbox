# Chipbox

## Presentation

Minimal network system inspired by PirateBox project: https://piratebox.cc/

This project is a lighter alternative, with only 2 tools but with less configuration impact. 
 
Enjoy, it's a free software !

## Features

* Chat, thanks to adamoutler/MinimalChatExtreme
* File sharing, thanks to muchweb/simple-php-upload

## Virtual Box image 

A Virtual Box image is available here: 
https://github.com/remipassmoilesel/chipbox/raw/master/virtualbox/Chipbox_OpenWRT.ova

Setup :

    File > Import virtual machine 
    
After launch and visit: http://VBOX_IP:2050

SSH credentials:

    Login:      root@VBOX_IP
    Password:   azerty

Get vbox_ip:

    On virtual machine screen, after launch type 'Enter'
    root@OpenWrt:/ ifconfig | less

You need to have an host-only network to access to the VM.
https://www.virtualbox.org/manual/ch06.html#network_hostonly

## Installation

This system work on OpenWRT Chaos Calmer. Its require a bit of disk memory, maybe you will have to do an 
extroot to extend your device.

https://wiki.openwrt.org/doc/howto/extroot

### Purpose

Here we will install Chipbox step by step with lighttpd to serve files, and nodogsplash to catch new
users and redirect them to Chipbox.

### Connection

Turn on the router :)
Connect to Openwrt and change the default password:
    
    $ telnet ROUTER_IP
    root@OpenWrt:/# passwd
    root@OpenWrt:/# exit
    
    $ ssh root@ROUTER_IP

### Install prerequisites

    root@OpenWrt:/# opkg update
    root@OpenWrt:/# opkg install unzip ca-certificates wget lighttpd \
        php5 php5-cgi lighttpd-mod-cgi php5-mod-openssl nodogsplash \
        php5-mod-session 
        
     Optionnal packages: curl git git-http vim

### Install project

    root@OpenWrt:/# mkdir -p /www && cd /www
    root@OpenWrt:/www# wget https://github.com/remipassmoilesel/chipbox/raw/master/dist/release.zip
    root@OpenWrt:/www# unzip release.zip
    root@OpenWrt:/www# rm release.zip

Be sure to let the right permissions on directory:
 
    root@OpenWrt:/# chown -R http:www-data /www/chipbox
    
### Configure softwares

Release port 80:

    root@OpenWrt:/# vim /etc/config/uhttpd
    
    config uhttpd 'main'
            list listen_http '0.0.0.0:85'
            list listen_http '[::]:85'
    
    root@OpenWrt:/# /etc/init.d/uhttpd restart
    
Configure Lighttpd:

    root@OpenWrt:/# vim /etc/lighttpd/lighttpd.conf
     
    server.document-root    = "/www/chipbox"
    server.port             = "80"
    
    # Optionnal, for debugging
    debug.log-request-handling = "enable" 
    dir-listing.encoding        = "utf-8"
    server.dir-listing          = "enable"

    root@OpenWrt:/# /etc/init.d/lighttpd enable
    root@OpenWrt:/# /etc/init.d/lighttpd start

Configure PHP (please adapt memory amounts):

    root@OpenWrt:/# vim /etc/php.ini

    ; Resource Limits
  
    max_execution_time = 60 
    memory_limit = 60M
    
    ; Data Handling 
    
    post_max_size = 60M

    ; File Uploads
  
    file_uploads = On
    upload_tmp_dir = "/tmp"
    upload_max_filesize = 60M
    max_file_uploads = 20

    ; Paths and Directories
    
    doc_root = "/www/chipbox"
    cgi.fix_pathinfo=1
    
    root@OpenWrt:/# vim /etc/lighttpd/conf.d/30-cgi.conf 

     cgi.assign       = ( ...
                       ".php" => "/usr/bin/php-cgi",
                       ... )

    
    root@OpenWrt:/# /etc/init.d/lighttpd restart

Configure nodogsplash:

    root@OpenWrt:/# vim /etc/config/nodogsplash
    
    config instance
        option enabled 1

    # put below the name of your network, eg. wlan0 
    option network 'lan' 

    root@OpenWrt:/# /etc/init.d/nodogsplashctl restart

Set custom splash:

    root@OpenWrt:/# mv /etc/nodogsplash/htdocs /etc/nodogsplash/htdocs.bak
    root@OpenWrt:/# mkdir -p /etc/nodogsplash/htdocs
    root@OpenWrt:/# ln -s /www/chipbox/splash.html /etc/nodogsplash/htdocs/
    root@OpenWrt:/# ln -s /www/chipbox/infoskel.html /etc/nodogsplash/htdocs/
    root@OpenWrt:/# ln -s /www/chipbox/images /etc/nodogsplash/htdocs/

Check nodogsplash status with: 

    root@OpenWrt:/# ndsctl status
    
Check listening ports with:
    
    root@OpenWrt:/# netstat -lntp
    
After you can visit an http ressource, nodogsplash will redirect you to the splash file.