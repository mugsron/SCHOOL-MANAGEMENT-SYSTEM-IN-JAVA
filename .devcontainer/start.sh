#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/../smart-campus"
: "${MYSQL_HOST:?Open this repository in its configured Codespace first}"
export MYSQL_PWD="${MYSQL_PASSWORD:?Missing database credentials}"
query() { mysql --protocol=TCP -h "$MYSQL_HOST" -u "$MYSQL_USER" "$MYSQL_DATABASE" -Nse "$1"; }
ready=false
for ((attempt=0; attempt<60; attempt++)); do
  if query 'SELECT 1' >/dev/null 2>&1; then ready=true; break; fi
  sleep 1
done
if [[ "$ready" != true ]]; then echo 'MySQL is not ready.' >&2; exit 1; fi
tables=$(query "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema=DATABASE()")
init=never
if [[ "$tables" = 0 ]]; then init=always; fi
unset MYSQL_PWD
mvn -B -ntp package
exec java -jar target/smart-campus-1.0.0.jar --server.address=0.0.0.0 --spring.sql.init.mode="$init"
