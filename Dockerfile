ARG CLICKHOUSE_VERSION
FROM clickhouse/clickhouse-server:${CLICKHOUSE_VERSION:-23}

ENV DEBIAN_FRONTEND='noninteractive'
ARG POSTGRES_VERSION

ARG TIMEZONE
ENV TZ=${TIMEZONE}

# If the certs directory exists, copy the certs and utilize them.
ARG BUILD_CONTEXT_PATH
COPY ${BUILD_CONTEXT_PATH}/cert[s]/* /tmp/certs/

# Install necessary packges
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        ca-certificates \
        gnupg \
        build-essential \
        lsb-release \
        git \
        cmake \
        libpoco-dev \
        libssl-dev \
        libicu-dev \
        unixodbc-dev \
        jq \
        openssl \
        unixodbc \
        gcc \
        libc-dev \
        g++ \
        python3 \
        python3-pip \
        dnsutils \
        zip \
        unzip && \
    cp /tmp/certs/* /usr/local/share/ca-certificates/ && \
    cp /tmp/certs/* /etc/ssl/certs/ && \
    update-ca-certificates --fresh && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null && \
    sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main' > /etc/apt/sources.list.d/pgdg.list" && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends \
        postgresql-client-${POSTGRES_VERSION} && \
    apt-get clean

# Clickhouse interserver port
EXPOSE 9000
EXPOSE 9009

# Clickhouse ODBC & JDBC Port
EXPOSE 9018
EXPOSE 9019
