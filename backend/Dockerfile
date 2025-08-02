# Use Node.js 18 Debian for better Prisma compatibility
FROM node:18-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    postgresql-client \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies for build)
RUN npm ci

# Copy source code
COPY . .

# Generate Prisma client
RUN npx prisma generate

# Build TypeScript
RUN npm run build

# Remove dev dependencies to reduce image size
RUN npm prune --production

# Create non-root user
RUN groupadd -g 1001 nodejs
RUN useradd -u 1001 -g nodejs -s /bin/bash -m nodejs

# Change ownership of the app directory
RUN chown -R nodejs:nodejs /app

# No script needed - we'll run commands directly
USER nodejs

# Expose port
EXPOSE 5001

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:5001/api/health || exit 1

# Start the application
CMD ["sh", "-c", "npx prisma migrate deploy && node dist/server.js"] 