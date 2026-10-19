#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
umask 077
if [[ -f app.env && -f db.env ]]; then exit 0; fi
if [[ -e app.env || -e db.env ]]; then
  echo 'One database environment file is missing. Restore the missing file; do not rotate credentials for an existing database.' >&2
  exit 1
fi
app_password=$(openssl rand -hex 32)
root_password=$(openssl rand -hex 32)
cat > db.env <<ENV
MYSQL_DATABASE=smartcampus
MYSQL_USER=smartcampus
MYSQL_PASSWORD=$app_password
MYSQL_ROOT_PASSWORD=$root_password
ENV
cat > app.env <<ENV
MYSQL_HOST=db
MYSQL_DATABASE=smartcampus
MYSQL_USER=smartcampus
MYSQL_PASSWORD=$app_password
SPRING_DATASOURCE_URL=jdbc:mysql://db:3306/smartcampus
SPRING_DATASOURCE_DRIVER_CLASS_NAME=com.mysql.cj.jdbc.Driver
SPRING_DATASOURCE_USERNAME=smartcampus
SPRING_DATASOURCE_PASSWORD=$app_password
SPRING_JPA_DATABASE_PLATFORM=org.hibernate.dialect.MySQLDialect
SPRING_JPA_HIBERNATE_DDL_AUTO=update
SPRING_SQL_INIT_MODE=never
SPRING_H2_CONSOLE_ENABLED=false
ENV
