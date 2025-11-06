# -------- Stage 1: Builder --------
FROM node:20-alpine AS builder

WORKDIR /app

# Copy dependency files from the inner folder
COPY petmanagement_backend_rajalakshmi/package*.json ./

# Install required system packages for native modules
RUN apk add --no-cache python3 make g++

# Install dependencies cleanly (production only)
RUN npm ci --omit=dev --legacy-peer-deps

# Copy the rest of the source code
COPY petmanagement_backend_rajalakshmi/ ./

# -------- Stage 2: Production --------
FROM node:20-alpine AS production

WORKDIR /app

ENV NODE_ENV=production

# Copy built app from builder
COPY --from=builder /app ./

# Expose the port (adjust if your app uses a different one)
EXPOSE 5000

# Start the server
CMD ["node", "server.js"]
