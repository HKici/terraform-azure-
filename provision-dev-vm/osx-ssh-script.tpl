cat << EOF >> ~/.ssh/config

Host ${hostname}
    hostname ${hostname}
    user ${user}
    identityfile ${identityfile}
EOF

