# Coolify Deployment Configuration

## Required Changes for Coolify

### 1. Environment Variables
Set these in Coolify's environment variables section:

```bash
# Database Configuration
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
POSTGRES_DB=notification_system
POSTGRES_USER=postgres
POSTGRES_PASSWORD=password

# Redis Configuration
REDIS_URL=redis://redis:6379

# Backend Configuration
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production

# Frontend Configuration
# Use your Coolify domain for the backend API
NEXT_PUBLIC_API_URL=https://your-coolify-domain.com:5001
# OR if using a subdomain:
# NEXT_PUBLIC_API_URL=https://api.your-coolify-domain.com
```

### 2. Docker Compose Configuration
- Use `docker-compose.prod.yml` in Coolify
- All services are configured with proper networking
- Health checks are enabled for all services

### 3. Port Configuration
- **Backend**: Port 5001
- **Frontend**: Port 3000
- **Database**: Port 5432
- **Redis**: Port 6379

### 4. Build Configuration
- **Build Command**: Leave empty (Docker handles this)
- **Install Command**: Leave empty (Docker handles this)
- **Start Command**: Leave empty (Docker handles this)

### 5. Service Dependencies
The services start in this order:
1. PostgreSQL (Database)
2. Redis
3. Backend (waits for DB and Redis)
4. Frontend (waits for Backend)

### 6. Health Checks
All services have health checks:
- Backend: `http://localhost:5001/api/health`
- Frontend: `http://localhost:3000`
- Database: PostgreSQL health check
- Redis: Redis ping

### 7. Automatic Migrations
The backend automatically runs Prisma migrations on startup.

## Deployment Steps

1. **Connect Repository**: Link your Git repository to Coolify
2. **Select Branch**: Choose main/master branch
3. **Use Docker Compose**: Select `docker-compose.prod.yml`
4. **Set Environment Variables**: Add all variables listed above
5. **Deploy**: Click deploy and monitor the logs

## Post-Deployment Verification

1. **Check Health**: All services should show as healthy
2. **Test API**: `curl http://your-domain:5001/api/health`
3. **Test Frontend**: Visit the frontend URL
4. **Test Notifications**: Create users, posts, likes, and comments

## Troubleshooting

### Common Issues:
1. **Database Connection**: Check DATABASE_URL format
2. **Redis Connection**: Check REDIS_URL format
3. **Port Conflicts**: Ensure ports are available
4. **Build Failures**: Check Docker build logs

### Logs to Monitor:
- Backend logs for API errors
- Frontend logs for build issues
- Database logs for connection problems
- Redis logs for cache issues 