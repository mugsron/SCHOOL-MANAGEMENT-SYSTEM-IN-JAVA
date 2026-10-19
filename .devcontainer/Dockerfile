FROM maven:3.9.9-eclipse-temurin-21
RUN apt-get update \
    && apt-get install -y --no-install-recommends default-mysql-client python3 curl \
    && rm -rf /var/lib/apt/lists/*
