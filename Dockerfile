FROM node:24-alpine
WORKDIR /app
COPY package.json ./
COPY app.js server.js db.js views.js ./
COPY public ./public
RUN mkdir -p /app/data && chown -R node:node /app

USER node

ENV NODE_ENV=production
ENV PORT=3000
EXPOSE 3000

# Container-native health check — mirrors the /healthz endpoint used by CI/CD.
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "fetch('http://localhost:3000/healthz').then(r=>process.exit(r.ok?0:1)).catch(()=>process.exit(1))"

CMD ["node", "server.js"]