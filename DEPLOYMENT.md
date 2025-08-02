# Deployment Guide

This guide covers deploying the Notification System POC to various platforms.

## Local Development

1. **Quick Setup:**
   ```bash
   ./setup.sh
   ```

2. **Manual Setup:**
   ```bash
   # Start infrastructure
   docker-compose up -d
   
   # Backend setup
   cd backend
   cp env.example .env
   npm install
   npx prisma generate
   npx prisma migrate dev
   npm run dev
   
   # Frontend setup
   cd ../frontend
   npm install
   npm run dev
   ```

## Cloud Deployment

### Option 1: Railway (Recommended)

**Backend:**
1. Create account at [Railway](https://railway.app)
2. Connect your GitHub repository
3. Set build command: `npm run build`
4. Set start command: `npm start`
5. Add environment variables:
   - `DATABASE_URL`: PostgreSQL connection string
   - `REDIS_URL`: Redis connection string
   - `JWT_SECRET`: Your secret key
6. Deploy

**Frontend:**
1. Create new service in Railway
2. Set build command: `npm run build`
3. Set start command: `npm start`
4. Add environment variable: `NEXT_PUBLIC_API_URL`: Your backend URL

**Database:**
1. Add PostgreSQL service in Railway
2. Copy connection string to backend environment

**Redis:**
1. Add Redis service in Railway
2. Copy connection string to backend environment

### Option 2: Vercel + Railway

**Frontend (Vercel):**
1. Connect GitHub repository to Vercel
2. Set build command: `npm run build`
3. Add environment variable: `NEXT_PUBLIC_API_URL`

**Backend (Railway):**
- Follow Railway backend deployment steps above

### Option 3: Heroku

**Backend:**
1. Create Heroku app
2. Add PostgreSQL addon
3. Add Redis addon
4. Set environment variables
5. Deploy with: `git push heroku main`

**Frontend:**
1. Create Heroku app
2. Set buildpacks for Node.js
3. Deploy with: `git push heroku main`

## Environment Variables

### Backend
```env
DATABASE_URL="postgresql://..."
REDIS_URL="redis://..."
JWT_SECRET="your-secret-key"
PORT=5000
```

### Frontend
```env
NEXT_PUBLIC_API_URL="https://your-backend-url.com"
```

## Database Migration

For production deployments, run:
```bash
npx prisma migrate deploy
```

## Monitoring

- **Backend**: Use Railway/Heroku logs
- **Database**: Monitor connection pool and query performance
- **Redis**: Monitor memory usage and connection count
- **Frontend**: Use Vercel analytics or similar

## Scaling Considerations

1. **Database**: Consider read replicas for high traffic
2. **Redis**: Use Redis Cluster for high availability
3. **Backend**: Scale horizontally with load balancer
4. **WebSocket**: Use Redis adapter for Socket.io clustering 