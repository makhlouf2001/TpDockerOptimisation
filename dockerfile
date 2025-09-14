FROM node:18-alpine

WORKDIR /app

COPY package*.json ./

RUN npm install --only=production

COPY . .

# Définir l'environnement en production
ENV NODE_ENV=production

USER node

EXPOSE 3000

CMD ["node", "server.js"]
