#!/system/bin/sh
PKG="app.ninjavpn.android"

while [ "$(getprop sys.boot_completed)" != "1" ]; do sleep 1; done
sleep 5

UID_NUM=$(dumpsys package $PKG | grep -m1 "userId=" | sed 's/.*userId=//')

if [ -n "$UID_NUM" ]; then
  cmd netpolicy add restrict-background-whitelist $UID_NUM
  cmd netpolicy remove restrict-background-blacklist $UID_NUM
  dumpsys deviceidle whitelist +$PKG
  cmd appops set $PKG RUN_IN_BACKGROUND allow
  cmd appops set $PKG RUN_ANY_IN_BACKGROUND allow
fi

cmd netpolicy set restrict-background false
settings put global data_saver_mode 0

log -t unrestrict_ninjavpn "Applied unrestrict policy for $PKG (uid=$UID_NUM)"
