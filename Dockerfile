FROM node:20-bookworm-slim AS frontend-builder
WORKDIR /build/frontend
COPY repo/frontend/package*.json ./
RUN npm config set registry https://registry.npmmirror.com \
    && npm ci
COPY repo/frontend/ ./
RUN npm run build

FROM maven:3.9.9-eclipse-temurin-17 AS backend-builder
WORKDIR /build/backend
COPY repo/backend/pom.xml ./
COPY repo/backend/settings.xml ./settings.xml
RUN mvn -s settings.xml -DskipTests dependency:go-offline
COPY repo/backend/src ./src
RUN mvn -s settings.xml -DskipTests package

FROM eclipse-temurin:17-jre-jammy

ENV DEBIAN_FRONTEND=noninteractive \
    JAVA_OPTS="-Xms256m -Xmx512m"

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    ca-certificates \
    nginx \
    && rm -rf /var/lib/apt/lists/*

COPY --from=backend-builder /build/backend/target/permission-system-1.0.0.jar /app/app.jar
COPY --from=frontend-builder /build/frontend/dist /usr/share/nginx/html
RUN rm -f /etc/nginx/sites-enabled/default
COPY repo/frontend/nginx.conf /etc/nginx/sites-enabled/default

RUN printf '%s\n' \
    '#!/usr/bin/env bash' \
    'set -euo pipefail' \
    '' \
    'java ${JAVA_OPTS} -jar /app/app.jar &' \
    'backend_pid=$!' \
    "nginx -g 'daemon off;' &" \
    'nginx_pid=$!' \
    '' \
    'cleanup() {' \
    '  kill "${backend_pid}" "${nginx_pid}" 2>/dev/null || true' \
    '}' \
    '' \
    'trap cleanup TERM INT' \
    'wait -n "${backend_pid}" "${nginx_pid}"' \
    'status=$?' \
    'cleanup' \
    'wait "${backend_pid}" "${nginx_pid}" 2>/dev/null || true' \
    'exit "${status}"' \
    > /usr/local/bin/start-app && chmod +x /usr/local/bin/start-app

EXPOSE 80 8000

CMD ["/usr/local/bin/start-app"]
