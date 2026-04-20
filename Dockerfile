FROM node:20-alpine AS ui-build
WORKDIR /usr/src/app
COPY my-app/package*.json ./my-app/
WORKDIR /usr/src/app/my-app
RUN npm ci
COPY my-app/ .
RUN npm run build

FROM node:20-alpine AS app
WORKDIR /usr/src/app
COPY api/package*.json ./api/
WORKDIR /usr/src/app/api
RUN npm ci
COPY api/ .
COPY --from=ui-build /usr/src/app/my-app/build ../my-app/build

EXPOSE 3080

CMD ["node", "server.js"]