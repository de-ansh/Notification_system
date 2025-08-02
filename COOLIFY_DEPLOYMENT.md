# Coolify Deployment Guide

## Prerequisites
- Coolify instance running
- Git repository with the notification system code
- Docker enabled on Coolify

## Deployment Steps

### 1. Connect Repository
1. In Coolify, go to "Projects" → "New Project"
2. Connect your Git repository
3. Select the branch (main/master)

### 2. Configure Build Settings
1. **Build Command**: Leave empty (Docker will handle this)
2. **Install Command**: Leave empty (Docker will handle this)
3. **Start Command**: Leave empty (Docker will handle this)

### 3. Docker Configuration
1. **Docker Compose**: Use `docker-compose.prod.yml`
2. **Dockerfile Path**: Leave empty (Docker Compose will handle this)

### 4. Environment Variables
Add these environment variables in Coolify:

#### Backend Environment Variables:
```
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

#### Frontend Environment Variables:
```
NEXT_PUBLIC_API_URL=http://localhost:5001
NODE_ENV=production
```

### 5. Port Configuration
- **Backend**: Port 5001
- **Frontend**: Port 3000
- **Database**: Port 5432
- **Redis**: Port 6379

### 6. Health Checks
The system includes health checks for all services:
- Backend: `http://localhost:5001/api/health`
- Frontend: `http://localhost:3000`
- Database: PostgreSQL health check
- Redis: Redis ping

### 7. Deployment
1. Click "Deploy" in Coolify
2. Monitor the build logs
3. Wait for all services to be healthy

## Troubleshooting

### Common Issues:

1. **Frontend server.js not found**:
   - Ensure Next.js standalone build is working
   - Check that `output: 'standalone'` is in `next.config.js`

2. **Backend package.json not found**:
   - Ensure Dockerfile properly copies package.json
   - Check that npm ci runs successfully

3. **Database connection issues**:
   - Verify DATABASE_URL environment variable
   - Check that PostgreSQL container is healthy

4. **Redis connection issues**:
   - Verify REDIS_URL environment variable
   - Check that Redis container is healthy

### Logs to Check:
- Backend logs: `docker-compose logs backend`
- Frontend logs: `docker-compose logs frontend`
- Database logs: `docker-compose logs postgres`
- Redis logs: `docker-compose logs redis`

## Testing the Deployment

Once deployed, test the system:

1. **Health Check**: Visit the frontend URL
2. **API Test**: `curl http://your-domain:5001/api/health`
3. **Create Users**: Use the frontend or API
4. **Test Notifications**: Create posts, likes, and comments

## Production Considerations

1. **Security**: Change default passwords and JWT secret
2. **SSL**: Configure SSL certificates
3. **Backup**: Set up database backups
4. **Monitoring**: Add monitoring and alerting
5. **Scaling**: Configure auto-scaling if needed 