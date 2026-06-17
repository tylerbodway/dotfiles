---
name: Build (Auto)
description: Full-access build agent that auto-accepts edits and bash commands
mode: primary
color: warning
permission:
  bash:
    "*": allow
    box uninstall *: deny
    bunx *: deny
    curl *: deny
    git push *: deny
    nc *: deny
    netcat *: deny
    npx *: deny
    pco connect *: deny
    pco console *: deny
    pco dbconnect *: deny
    pco ssm *: deny
    pnpx *: deny
    scp *: deny
    sftp *: deny
    ssh *: deny
    su *: deny
    sudo *: deny
    wget *: deny
    yarn dlx *: deny
  edit:
    "*": allow
    .env: deny
    .env.*: deny
    .env.local: deny
    secrets/**: deny
    .secrets/**: deny
    credentials*: deny
    "*.pem": deny
    "*.key": deny
---

Behave identically to the default primary agent. The only difference is that file edits and bash commands are auto-accepted without prompting, except for a set of obviously sensitive operations.
