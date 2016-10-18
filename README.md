# Chipbox

## Presentation

Minimal network system inspired by PirateBox project: https://piratebox.cc/

This project is a lighter alternative, with only 2 tools but with less configuration impact. 
 
Enjoy, it's a free software !

## Features

* Chat, thanks to adamoutler/MinimalChatExtreme
* File sharing, thanks to muchweb/simple-php-upload

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
    
    $ telnet 192.168.56.10
    root@OpenWrt:/www# passwd
    root@OpenWrt:/www# exit
    
    $ ssh root@192.168.56.10

### Install prerequisites

    root@OpenWrt:/www# opkg update
    root@OpenWrt:/www# opkg install unzip ca-certificates wget lighttpd \
        php5 php5-cgi lighttpd-mod-cgi php5-mod-openssl nodogsplash \
        php5-mod-session 
        
     Optionnal packages: curl git git-http vim

### Install project

    root@OpenWrt:/www# mkdir -p /www && cd /www
    root@OpenWrt:/www# wget https://github.com/remipassmoilesel/chipbox/raw/master/dist/release.zip
    root@OpenWrt:/www# unzip release.zip
    root@OpenWrt:/www# rm release.zip

Be sure to let the right permissions on directory:
 
    root@OpenWrt:/www# chown -R http:www-data /www/chipbox
    
### Configure softwares

Release port 80:

    root@OpenWrt:/www# vim /etc/config/uhttpd
    
    config uhttpd 'main'
            list listen_http '0.0.0.0:85'
            list listen_http '[::]:85'
    
    root@OpenWrt:/www# /etc/init.d/uhttpd restart
    
Configure Lighttpd:

    root@OpenWrt:/www# vim /etc/lighttpd/lighttpd.conf
     
    server.document-root    = "/www/chipbox"
    server.port             = "80"
    
    # Optionnal, for debugging
    debug.log-request-handling = "enable" 
    dir-listing.encoding        = "utf-8"
    server.dir-listing          = "enable"

    root@OpenWrt:/www# /etc/init.d/lighttpd enable
    root@OpenWrt:/www# /etc/init.d/lighttpd start

Configure PHP (please adapt memory amounts):

    root@OpenWrt:/www# vim /etc/php.ini

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
    
    root@OpenWrt:/www# vim /etc/lighttpd/conf.d/30-cgi.conf 

     cgi.assign       = ( ...
                       ".php" => "/usr/bin/php-cgi",
                       ... )

    
    root@OpenWrt:/www# /etc/init.d/lighttpd restart

Configure nodogsplash:

    root@OpenWrt:/www# vim /etc/config/nodogsplash
    
    config instance
        option enabled 1

    # put below the name of your network, eg. wlan0 
    option network 'lan' 

    root@OpenWrt:/www# /etc/init.d/nodogsplashctl restart

Set custom splash:

    root@OpenWrt:/www# vim /etc/fstab
    
    /www/chipbox /etc/nodogsplash/htdocs        none    bind
    
    root@OpenWrt:/www# mount -a

Check nodogsplash status with: 

    root@OpenWrt:/www# ndsctl status
    
Check listening ports with:
    
    root@OpenWrt:/www# netstat -lntp
    
After you can visit an http ressource, nodogsplash will redirect you to the splash file.

# Virtual box image 

Available here: 

Setup and visit: vbox_ip:2050
    
    
    
    
    
    
    
    