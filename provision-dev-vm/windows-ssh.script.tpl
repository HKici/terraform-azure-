add-content path c:/users/UserName/.ssh/config -value @'

Host ${hostname}
    hostname ${hostname}
    user ${user}
    identityfile ${identityfile}
'@
