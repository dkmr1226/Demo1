# ============================
# Stage 1: Build dependencies
# ============================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy only package files first (better caching)
COPY package*.json ./

# Install only production dependencies
RUN npm ci --omit=dev && npm cache clean --force

# Copy the rest of the source code
COPY . .

# ============================
# Stage 2: Run minimal app
# ============================
FROM node:20-alpine

# Set working directory
WORKDIR /app

# Copy only the necessary files from builder
COPY --from=builder /app . 

# Expoe the port
EXPOSE 8080 

# Run the app
CMD ["npm", "start"]
