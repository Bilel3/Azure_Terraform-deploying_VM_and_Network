add-content -path c:/users/bilel/.ssh/config -value @'
Host ${hostname}
    HostName $(hostname}
    User ${user}
    IdentityFile ${identityfile}
'@
