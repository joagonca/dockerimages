# Nextcloud Dockerfile

This Dockerfile takes the base Nextcloud image, and applies some changes on top:
* Update the *opcache* configuration to the one recommended by Nextcloud [1]
* Enable *Redis* as a session handler
* Install *FFMpeg* to enable preview generation for videos
* Install *intel-media-va-driver* for hardware-accelerated video decoding, and make /dev/dri/renderD128 accessible at container start (via the entrypoint wrapper)
* Install the *bz2* PHP extension
* SVG preview generation relies on *libmagickcore-7.q16-10-extra*, which is already included in the base image

[1] https://docs.nextcloud.com/server/latest/admin_manual/installation/server_tuning.html