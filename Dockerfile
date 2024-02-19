

FROM node:20 as dependencies

WORKDIR /app
COPY package.json ./
RUN npm install --legacy-peer-deps

FROM node:20 as builder
WORKDIR /app
COPY . .
COPY --from=dependencies /app/node_modules ./node_modules

RUN npm run build

FROM node:20 as runner
WORKDIR /app

ENV NODE_ENV production

COPY --from=builder /app/public ./public

COPY --from=builder /app/.next ./.next

COPY --from=builder /app/node_modules ./node_modules

COPY --from=builder /app/package.json ./package.json

EXPOSE 3000


CMD ["npm", "start"]

