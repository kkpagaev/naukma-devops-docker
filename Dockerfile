FROM node:16 as build-stage

WORKDIR /build
COPY package.json package-lock.json ./
RUN npm install
COPY ./ .
RUN npm run build

FROM node:16 as production-stage

WORKDIR /app
COPY --chown=node:node --from=build-stage /build/package.json /build/package-lock.json /app/

RUN npm ci

USER node

COPY --chown=node:node --from=build-stage /build/dist /app/dist/

EXPOSE 3000

CMD ["node", "/app/dist/index.js"]

