Simple script for resend SMS from GSM modem to email
====================================================

## Install OpenWRT or may be another Linux to your device

## Use #ExtRoot overlay to expand flash disk of root file system
> opkg install kmod-usb-core block-mount kmod-fs-ext4 kmod-usb-storage-extras
> opkg install kmod-crypto-crc32c kmod-lib-crc32c
> mkfs.ext4 /dev/sdaX -L ext4-overlay
> mount /dev/sdaX /mnt
> tar -C /overlay -cvf - . | tar -C /mnt -xf -
> umount /mnt
> block detect > /etc/config/fstab
> vim /etc/config/fstab
```
config 'mount'
	option	target	'/overlay' # SET IT
	option	uuid	'xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxxx'
	option	enabled	'1' # ENABLE IT
```
> reboot
 
## Install smstools (smstools3)
```
opkg update
opkg install smstools3
```

## Configure smstools3 - loock files in `to_etc` directory
> vim /etc/smstools.conf

## Install `mailsend`
> opkg install mailsend

## Copy files to `/opt` and to `/etc`
> mkdir -p /opt/sms2email
> cp ./sms2email.sh   /opt/sms2email/
> cp ./gsm_handler.sh /opt/sms2email/
> cp ./sms2email.conf /etc

## Edit /etc/sms2email.conf
> vim /etc/sms2email.conf

## Configure `cron`
> crontab -e
```
# min   hour  m/day  month  w/day   
# 0-59  0-23  1-31   1-12   0-6
   30   */1    *      *      *   /opt/sms2email/sms2email.sh
```

