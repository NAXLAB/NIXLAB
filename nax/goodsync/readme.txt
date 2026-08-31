#After rebuilding, run these commands to connect your goodsync account

sudo GS_OS_SERVER_PROFILE=/etc/goodsync gs-server /profile=/etc/goodsync/server /set-admin=email@address.com:password
sudo GS_OS_SERVER_PROFILE=/etc/goodsync gs-server /profile=/etc/goodsync/server /new-certificate=email@address.com

#How to check to make sure everything works

# 1. Mounts are up
systemctl status mnt-xdrive.mount mnt-zaigomaat.mount

# 2. GoodSync server running
systemctl status goodsync.service

# 3. Runner running
systemctl status goodsync-runner.service

# 4. Oneshot completed (should be inactive/dead, exit 0 or 255)
systemctl status zaigomaat-sync.service

# 5. Runner picked up the job and is watching
systemctl status goodsync-runner.service

# 6. State files exist (proves last sync completed cleanly)
ls /mnt/xdrive/_gsdata_/_file_state_v4._gs
ls /mnt/zaigomaat/_gsdata_/_file_state_v4._gs

# 8. Do a test analyze and confirm change count is low (not 600k again)
gsync analyze "zaigomaat-sync"