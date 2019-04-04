#/bin/sh -ex
cd "$(dirname "$0")"

./deploy-target.sh staging 'ssh://root@178.128.143.69' "$@"
