#Builder
FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

#Runner
FROM node:18-alpine AS runner

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production

COPY --from=builder /app/server.js ./ 

EXPOSE 3000

CMD ["node", "server.js"]
