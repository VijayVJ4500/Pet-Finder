# -------- Stage 1: Builder --------
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only dependency files first
COPY package*.json ./

# Install required system packages for native modules
RUN apk add --no-cache python3 make g++

# Install dependencies cleanly (production only)
RUN npm ci --omit=dev --legacy-peer-deps

# Copy all source files
COPY . .

# (Optional) Build step, if you have a build script (for TypeScript etc.)
# RUN npm run build

# -------- Stage 2: Production --------
FROM node:20-alpine AS production

# Set working directory
WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app ./

# Expose the port your backend runs on
EXPOSE 3000

# Command to start your server
CMD ["npm", "start"]
