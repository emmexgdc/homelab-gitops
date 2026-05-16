FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY tsconfig.json ./
COPY src ./src

RUN npm run build


FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY package*.json ./
RUN npm install --omit=dev \
    && addgroup -g 10001 -S app \
    && adduser -u 10001 -S app -G app

COPY --from=builder /app/dist ./dist

RUN chown -R 10001:10001 /app

USER 10001

EXPOSE 8080

CMD ["node", "dist/index.js"]
