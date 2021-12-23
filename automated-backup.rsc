:local emailAddress "your-email@example.com"
:local backupPassword ""

########################################################

:local scriptName             "[Automated Backup]"

:local deviceIdentityName     [/system identity get name];
:local deviceRbModel          [/system routerboard get model];
:local deviceRbSerialNumber   [/system routerboard get serial-number];
:local deviceOsVerInst        [/system package update get installed-version];
:local deviceUpdateChannel    [/system package update get channel];
:local dateTime               ([:pick [/system clock get date] 7 11] . [:pick [/system clock get date] 0 3] . [:pick [/system clock get date] 4 6] . "-" . [:pick [/system clock get time] 0 2] . [:pick [/system clock get time] 3 5] . [:pick [/system clock get time] 6 8]);

:local backupName             "$deviceIdentityName.$deviceRbModel.$deviceRbSerialNumber.v$deviceOsVerInst.$deviceUpdateChannel.$dateTime";
:local backupFileSys          "$backupName.backup";
:local backupFileConfig       "$backupName-system";
:local backupFileConfigRsc    "$backupFileConfig.rsc";
:local backupFileUser         "$backupName-user";
:local backupFileUserRsc      "$backupFileUser.rsc";

:log info "$scriptName Performaing back up...";

/system backup save name=$backupFileSys password=$backupPassword;
:log info "$scriptName System Backup ...Done";

/export show-sensitive terse file=$backupFileConfig;
:log info "$scriptName System Config Export ...Done";

/user export terse file=$backupFileUser
:log info "$scriptName User Export ...Done"; 
:delay 5s;	

:log info "$scriptName Sending backup email to $emailAddress";

:local mailSubject            "Mikrotik backup - $deviceIdentityName"
:local mailBody               "System backups were created and attached to this email.\n\nDevice: $deviceIdentityName\nModel: $deviceRbModel\nSerial Number: $deviceRbSerialNumber\nRouterOS Version: $deviceOsVerInst";
:local mailAttachments		    {$backupFileSys;$backupFileConfigRsc;$backupFileUserRsc};

:do {/tool e-mail send to=$emailAddress subject=$mailSubject body=$mailBody file=$mailAttachments;} on-error={
    :delay 5s;
    :log error "$scriptName Could not send email message ($[/tool e-mail get last-status]).";
}

:delay 10s
:log info "$scriptName Removing temp files.";
/file remove $mailAttachments; 
:log info "$scriptName Complete.";
