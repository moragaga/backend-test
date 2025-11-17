FROM node:22 AS build

WORKDIR /usr/app

COPY . /usr/app

RUN npm install

RUN npm run lint

RUN npm run test:cov

RUN npm run build

FROM node:20-alpine AS prod

WORKDIR /usr/app

COPY --from=build /usr/app/dist /usr/app
COPY --from=build /usr/app/package*.json /usr/app

RUN npm install --only=production

CMD ["node", "main"]
