# Node 20 LTS. This was pinned to node:14, which reached end of life in April
# 2023 and no longer receives security fixes; the image is used for the Heroku
# container deploy as well as local docker-compose, so it needs a supported base.
FROM node:20-slim

WORKDIR /usr/src/app

# Copy manifests first so `docker build` reuses the install layer whenever only
# application code has changed.
COPY package.json package-lock.json ./

# `npm ci` installs exactly what package-lock.json pins, unlike `npm install`
# which may resolve newer versions at build time. Every dependency here is a
# runtime one, so dev packages are omitted.
RUN npm ci --omit=dev

COPY . .

# Documentation only -- Heroku ignores EXPOSE and assigns $PORT at runtime,
# which app.js reads. Locally, docker-compose maps this port.
EXPOSE 3000

CMD ["node", "app/app.js"]
