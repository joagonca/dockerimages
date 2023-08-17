# Nextcloud Dockerfile

This Dockerfile takes the base Nextcloud image, and applies some changes on top:
* Update the *opcache* configuration to the one recommended by Nextcloud [1]
* Enable *Redis* as a session handler
* Install *FFMpeg* to enable preview generation for videos
* Install *libmagickcore-6.q16* to enable preview generation for SVG

[1] https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html