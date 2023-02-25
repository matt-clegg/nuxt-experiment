ARG NODE_VERSION=node:16-bullseye-slim

FROM $NODE_VERSION AS base

RUN mkdir -p /app
WORKDIR /app

COPY ./package.json .
COPY ./package-lock.json .
RUN npm install && npm cache clean --force

FROM base AS production-base

COPY . .
RUN npm run build

FROM $NODE_VERSION AS production

WORKDIR /app/
COPY --from=production-base /app/.output .output

ENV NUXT_HOST=0.0.0.0

ENV NODE_ENV=production

CMD [ "node", "/app/.output/server/index.mjs" ]