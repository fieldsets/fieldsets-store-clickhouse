ARG CLICKHOUSE_VERSION
FROM clickhouse/clickhouse-server:${CLICKHOUSE_VERSION:-23}

ENV DEBIAN_FRONTEND='noninteractive'
ARG POSTGRES_VERSION

ARG TIMEZONE
ENV TZ=${TIMEZONE}

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
        libicu66 \
        unixodbc \
        gcc \
        libc-dev \
        g++ \
        python3 \
        python3-pip \
        dnsutils \
        zip \
        unzip && \
    curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null && \
    sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main' > /etc/apt/sources.list.d/pgdg.list" && \
    update-ca-certificates && \
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

