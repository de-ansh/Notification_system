#!/bin/bash

echo "🚀 Setting up Notification System POC..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start database and Redis
echo "📦 Starting PostgreSQL and Redis containers..."
docker-compose up -d

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
sleep 10

# Setup backend
echo "🔧 Setting up backend..."
cd backend

# Copy environment file
if [ ! -f .env ]; then
    cp env.example .env
    echo "✅ Created .env file"
fi

# Install dependencies
echo "📦 Installing backend dependencies..."
npm install

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npx prisma generate

# Run database migrations
echo "🗄️ Running database migrations..."
npx prisma migrate dev --name init

# Build TypeScript
echo "🔧 Building TypeScript..."
npm run build

cd ..

# Setup frontend
echo "🔧 Setting up frontend..."
cd frontend

# Install dependencies
echo "📦 Installing frontend dependencies..."
npm install

cd ..

echo "✅ Setup complete!"
echo ""
echo "🎉 To start the application:"
echo "1. Backend: cd backend && npm run dev"
echo "2. Frontend: cd frontend && npm run dev"
echo ""
echo "🌐 Access the application at:"
echo "- Frontend: http://localhost:3000"
echo "- Backend API: http://localhost:5001"
echo "- Database: localhost:5432"
echo "- Redis: localhost:6379" 