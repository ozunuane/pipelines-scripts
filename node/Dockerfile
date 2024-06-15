FROM node:16-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY . .
RUN npm install

RUN npm run build
RUN npm prune

WORKDIR /app

EXPOSE 8080 5075

CMD ["node", "dist/server.js"]
