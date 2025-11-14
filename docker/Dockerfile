# syntax=docker/dockerfile:1
FROM node:18-alpine AS build

WORKDIR /app


ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

COPY package*.json ./


RUN npm ci --only=production


COPY . .

######################
## runtime stage
######################
FROM node:18-alpine AS runtime

WORKDIR /app


LABEL org.opencontainers.image.title="your-project-name" \
      org.opencontainers.image.description="Simple app to demonstrate Docker/DevOps skills" \
      org.opencontainers.image.url="https://github.com/your/repo" \
      org.opencontainers.image.licenses="MIT"


RUN addgroup -S appgroup && adduser -S appuser -G appgroup


COPY --from=build --chown=appuser:appgroup /app /app

USER appuser

ENV NODE_ENV=production
EXPOSE 3000


HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O- http://localhost:3000/health || exit 1


CMD ["node", "server.js"]
