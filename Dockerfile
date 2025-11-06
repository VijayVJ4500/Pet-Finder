# ---- Base builder ----
FROM node:20-alpine AS builder
WORKDIR /app

# Copy only dependency files first (for caching)
COPY package*.json ./

# Install production dependencies
RUN npm install --omit=dev

# Copy the rest of the source code
COPY . .

# ---- Runtime image ----
FROM node:20-alpine AS runtime
WORKDIR /app

ENV NODE_ENV=production \
    PORT=5000

# Use existing non-root user
USER node

# Copy production dependencies and source
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app ./

EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
  CMD node -e "require('http').get('http://127.0.0.1:'+(process.env.PORT||5000)+'/',res=>{if(res.statusCode!==200)process.exit(1)}).on('error',()=>process.exit(1))"

CMD ["node","server.js"]
