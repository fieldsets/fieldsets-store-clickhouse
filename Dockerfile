ARG CLICKHOUSE_VERSION
FROM clickhouse/clickhouse-server:${CLICKHOUSE_VERSION:-23}

ENV DEBIAN_FRONTEND='noninteractive'
ARG POSTGRES_VERSION

ARG TIMEZONE
ENV TZ=${TIMEZONE}

# If the certs directory exists, copy the certs and utilize them.
ARG BUILD_CONTEXT_PATH
COPY ${BUILD_CONTEXT_PATH}bin/root-certs.sh /root/.local/bin/root-certs.sh
COPY ${BUILD_CONTEXT_PATH}cert[s]/* /tmp/certs/

# Install necessary packges
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        coreutils \
        wget \
        apt-transport-https \
        software-properties-common \
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
        dnsutils \
        net-tools \
        openssh-client \
        zip \
        unzip

    # Break cert management into its own layer as it is dependent on presence or absence of a cert
    RUN bash /root/.local/bin/root-certs.sh /tmp/certs

    RUN curl https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor | tee /etc/apt/trusted.gpg.d/apt.postgresql.org.gpg >/dev/null && \
    sh -c "echo 'deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main' > /etc/apt/sources.list.d/pgdg.list" && \
    curl https://packages.fluentbit.io/fluentbit.key | gpg --dearmor | tee /usr/share/keyrings/fluentbit-keyring.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/fluentbit-keyring.gpg] https://packages.fluentbit.io/ubuntu/$(lsb_release -cs) $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/fluent-bit.list && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends \
        fluent-bit \
        pgdg-keyring \
        postgresql-client-${POSTGRES_VERSION} && \
    apt-get clean && \
    ln -s /opt/fluent-bit/bin/fluent-bit /usr/local/bin/fluent-bit

EXPOSE 8123
EXPOSE 9440

# Clickhouse interserver port
EXPOSE 9000
EXPOSE 9009

# Clickhouse ODBC & JDBC Port
EXPOSE 9018
EXPOSE 9019
