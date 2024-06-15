# FROM node:12-alpine AS builder

# WORKDIR /app

# COPY package*.json ./
# COPY . .
# RUN npm install

# RUN npm run build
# RUN npm prune

# WORKDIR /app

# EXPOSE 8080

# CMD ["node", "dist/server.js"]



FROM node:16-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN ["yarn", "install"]

COPY . .

RUN ["yarn", "run", "build"]
RUN ["npm", "prune", "--production"]

FROM node:16-alpine AS production
COPY --from=builder /app .

EXPOSE 8080
CMD ["node", "dist/server.js"]