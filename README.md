# mikrotik-automated-backup

## How to install

Make sure you have setup your email settings (not documented here)

### Install the script

1. In Winbox, open Systems -> Scripts
1. Create a new script and call it "automated-backup"
1. Copy & Paste `automated-backup.rsc` from the repo into the script section
1. Change the top 2 lines (emailAddress and backupPassword)
1. "Apply" to save
1. "Run Script" to test

### Schedule the script

1. Open System -> Scheduler
1. Create a new schedule and name it "automated-backups" and enter the on-event of `/system script run automated-backup;`
1. Set when to fire '1d' for every day.
1. Apply to save.

or run

```mikrotik
/system scheduler 
add comment="automated-backups" disabled=no interval=1d name="automated-backups" \
on-event="/system script run automated-backup;" start-date=jan/01/1970 start-time=00:00:00
```
