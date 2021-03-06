#!/sbin/busybox sh
DEST=/system/xbin/su

/sbin/busybox mount -o remount,rw /system /system

/sbin/busybox rm /system/bin/su
/sbin/busybox rm /system/xbin/su
/sbin/busybox cat /vendor/files/su-3.0.3 > $DEST
/sbin/busybox chown 0.0 /system/xbin/su
/sbin/busybox chmod 6755 /system/xbin/su

lightsmd5sum=`/sbin/busybox md5sum /system/lib/hw/lights.SC-02C.so | /sbin/busybox awk '{print $1}'`
blnlightsmd5sum=`/sbin/busybox md5sum /vendor/files/lights.SC-02C.so | /sbin/busybox awk '{print $1}'`
if [ "${lightsmd5sum}a" != "${blnlightsmd5sum}a" ]; then
    echo "Copying liblights"
    /sbin/busybox mv /system/lib/hw/lights.SC-02C.so /system/lib/hw/lights.SC-02C.so.BAK
    /sbin/busybox cp /vendor/files/lights.SC-02C.so /system/lib/hw/lights.SC-02C.so
    /sbin/busybox chown 0.0 /system/lib/hw/lights.SC-02C.so
    /sbin/busybox chmod 644 /system/lib/hw/lights.SC-02C.so
fi;

# Mod surfaceflinger for Fancy Rotation
surfaceflingers_md5sum=`/sbin/busybox md5sum /system/lib/libsurfaceflinger.so | /sbin/busybox awk '{print $1}'`
surfaceflingers_mod_md5sum=`/sbin/busybox md5sum /vendor/files/libsurfaceflinger.so.samsung | /sbin/busybox awk '{print $1}'`
if [ "${surfaceflingers_md5sum}a" != "${surfaceflingers_mod_md5sum}a" ]; then
    echo "Copying surfaceflingers"
    /sbin/busybox mv /system/lib/libsurfaceflinger.so /system/lib/libsurfaceflinger.so.BAK
    /sbin/busybox cp /vendor/files/libsurfaceflinger.so.samsung /system/lib/libsurfaceflinger.so
    /sbin/busybox chown 0.0 /system/lib/libsurfaceflinger.so
    /sbin/busybox chmod 644 /system/lib/libsurfaceflinger.so
fi;

# Mod surfaceflinger_client for Fancy Rotation
surfaceflinger_client_md5sum=`/sbin/busybox md5sum /system/lib/libsurfaceflinger_client.so | /sbin/busybox awk '{print $1}'`
surfaceflinger_client_mod_md5sum=`/sbin/busybox md5sum /vendor/files/libsurfaceflinger_client.so | /sbin/busybox awk '{print $1}'`
if [ "${surfaceflinger_client_md5sum}a" != "${surfaceflinger_client_mod_md5sum}a" ]; then
    echo "Copying surfaceflinger_client"
    /sbin/busybox mv /system/lib/libsurfaceflinger_client.so /system/lib/libsurfaceflinger_client.so.BAK
    /sbin/busybox cp /vendor/files/libsurfaceflinger_client.so /system/lib/libsurfaceflinger_client.so
    /sbin/busybox chown 0.0 /system/lib/libsurfaceflinger_client.so
    /sbin/busybox chmod 644 /system/lib/libsurfaceflinger_client.so
fi;

/sbin/busybox rm /system/app/CWMManager.apk
/sbin/busybox rm /system/app/CWMManager.odex
/sbin/busybox rm /data/dalvik-cache/*CWMManager*
/sbin/busybox rm /data/app/eu.chainfire.cfroot.cwmmanager*.apk
/sbin/busybox cat /vendor/files/CWMManager.apk > /system/app/CWMManager.apk
/sbin/busybox chown 0.0 /system/app/CWMManager.apk
/sbin/busybox chmod 644 /system/app/CWMManager.apk

/sbin/busybox rm /system/app/TweakGS2.apk
/sbin/busybox rm /system/app/TweakGS2.odex
/sbin/busybox rm /data/dalvik-cache/*TweakGS2*
/sbin/busybox rm /data/app/net.sakuramilk.TweakGS2*.apk
/sbin/busybox cat /vendor/files/TweakGS2.apk > /system/app/TweakGS2.apk
/sbin/busybox chown 0.0 /system/app/TweakGS2.apk
/sbin/busybox chmod 644 /system/app/TweakGS2.apk

/sbin/busybox rm /system/app/AppWidgetPicker.apk
/sbin/busybox rm /system/app/AppWidgetPicker.odex
/sbin/busybox rm /data/dalvik-cache/*AppWidgetPicker*
/sbin/busybox cat /vendor/files/AppWidgetPicker-1.2.3.apk > /system/app/AppWidgetPicker.apk
/sbin/busybox chown 0.0 /system/app/AppWidgetPicker.apk
/sbin/busybox chmod 644 /system/app/AppWidgetPicker.apk

# Bravia Engine Install
/sbin/busybox rm /system/etc/be_movie
/sbin/busybox rm /system/etc/be_photo
/sbin/busybox cat /vendor/files/be_movie > /system/etc/be_movie
/sbin/busybox cat /vendor/files/be_photo > /system/etc/be_photo
/sbin/busybox chmod 0755 /system/etc/be_movie
/sbin/busybox chmod 0755 /system/etc/be_photo
/sbin/busybox chown 0.0 /system/etc/be_movie
/sbin/busybox chown 0.0 /system/etc/be_photo

# copy sqlite3
/sbin/busybox cat /vendor/files/sqlite3 > /system/bin/sqlite3

# set sqlite3 permissions
/sbin/busybox chown 0.2000 /system/bin/sqlite3
/sbin/busybox chmod 775 /system/bin/sqlite3

# tether_dun_required 0
r=`/system/bin/sqlite3 /data/data/com.android.providers.settings/databases/settings.db "select * from secure where name='tether_dun_required';"`
if [ "$r" == "" ]; then
/system/bin/sqlite3 /data/data/com.android.providers.settings/databases/settings.db "insert into secure values (null, 'tether_dun_required','0');"
else
/system/bin/sqlite3 /data/data/com.android.providers.settings/databases/settings.db "update secure set value='0' where name='tether_dun_required';"
fi
/sbin/busybox rm /system/bin/sqlite3

# Carrier indicate 1line
/sbin/busybox rm  /system/etc/spn-conf.xml
/sbin/busybox cat /vendor/files/spn-conf.xml > /system/etc/spn-conf.xml
/sbin/busybox chown 0.0 /system/etc/spn-conf.xml
/sbin/busybox chmod 644 /system/etc/spn-conf.xml

/sbin/busybox mount -o remount,ro /system /system

