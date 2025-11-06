# -------- Stage 1: Build Stage --------
FROM node:20-alpine AS build

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json first
COPY package*.json ./

# Install required system packages (for native dependencies)
RUN apk add --no-cache python3 make g++

# Install production dependencies cleanly
RUN npm ci --omit=dev --legacy-peer-deps

# Copy remaining source code
COPY . .

# (Optional) If building a frontend or transpiling TypeScript
# RUN npm run build

# -------- Stage 2: Production Stage --------
FROM node:20-alpine AS production

WORKDIR /app

# Copy only the necessary files from build stage
COPY --from=build /app ./

# Expose app port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]
