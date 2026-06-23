After rebuilding, run these commands to connect your goodsync account

sudo GS_OS_SERVER_PROFILE=/etc/goodsync gs-server /profile=/etc/goodsync/server /set-admin=email@address.com:password
sudo GS_OS_SERVER_PROFILE=/etc/goodsync gs-server /profile=/etc/goodsync/server /new-certificate=email@address.com