# Separate Deployment Guide for Coolify

## 🎯 Why Separate Deployments?

**Benefits:**
- ✅ **Independent scaling**: Scale frontend and backend separately
- ✅ **Faster deployments**: Deploy only what changed
- ✅ **Better resource management**: Allocate resources per service
- ✅ **Easier debugging**: Isolate issues to specific services
- ✅ **No permission conflicts**: Avoid Docker permission issues

## 🚀 Deployment Strategy

### Option 1: Two Separate Projects in Coolify
- **Backend Project**: Database + Redis + Backend API
- **Frontend Project**: Next.js Frontend only

### Option 2: Single Project with Multiple Services
- **Backend Service**: Database + Redis + Backend API
- **Frontend Service**: Next.js Frontend only

## 📋 Step-by-Step Setup

### Step 1: Create Backend Project/Service

**Docker Compose File**: `docker-compose.backend.yml`

**Environment Variables:**
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

**Services:**
- `postgres` (Database)
- `redis` (Cache)
- `backend` (API Server)

### Step 2: Create Frontend Project/Service

**Docker Compose File**: `docker-compose.frontend.yml`

**Environment Variables:**
```bash
NEXT_PUBLIC_API_URL=http://your-backend-domain.com:5001
NODE_ENV=production
PORT=3000
```

**Services:**
- `frontend` (Next.js App)

## 🔧 Coolify Configuration

### Backend Project Setup

1. **Create new project** in Coolify
2. **Connect repository** and select branch
3. **Use Docker Compose**: Select `docker-compose.backend.yml`
4. **Set environment variables** (listed above)
5. **Deploy**

### Frontend Project Setup

1. **Create new project** in Coolify
2. **Connect repository** and select branch
3. **Use Docker Compose**: Select `docker-compose.frontend.yml`
4. **Set environment variables** (listed above)
5. **Deploy**

## 🌐 Domain Configuration

### Backend Domain
- **Domain**: `api.your-domain.com` or `your-domain.com:5001`
- **Port**: 5001
- **Health Check**: `/api/health`

### Frontend Domain
- **Domain**: `app.your-domain.com` or `your-domain.com:3000`
- **Port**: 3000
- **Health Check**: `/`

## 🔗 Connecting Frontend to Backend

### Option 1: Use Backend Domain
```bash
NEXT_PUBLIC_API_URL=http://api.your-domain.com
```

### Option 2: Use IP Address
```bash
NEXT_PUBLIC_API_URL=http://your-server-ip:5001
```

### Option 3: Use Coolify Domain
```bash
NEXT_PUBLIC_API_URL=http://your-coolify-backend-domain.com:5001
```

## 🧪 Testing Separate Deployments

### Test Backend
```bash
curl http://your-backend-domain.com:5001/api/health
```

### Test Frontend
```bash
curl -I http://your-frontend-domain.com:3000
```

### Test Connection
1. Visit frontend URL
2. Check browser console for API connection errors
3. Try creating a user or post

## 🔧 Troubleshooting

### Issue 1: Frontend Can't Connect to Backend
- **Check**: Backend is running and accessible
- **Check**: `NEXT_PUBLIC_API_URL` is correct
- **Check**: CORS is configured properly

### Issue 2: Permission Errors
- **Solution**: Separate deployments avoid permission conflicts
- **Check**: Dockerfile permissions are set correctly

### Issue 3: Port Conflicts
- **Solution**: Each service runs on its own port
- **Backend**: Port 5001
- **Frontend**: Port 3000

## 📊 Benefits of This Approach

1. **Independent Scaling**: Scale frontend and backend based on demand
2. **Faster Deployments**: Deploy only the service that changed
3. **Better Resource Allocation**: Allocate CPU/memory per service
4. **Easier Maintenance**: Update services independently
5. **Better Monitoring**: Monitor each service separately
6. **No Permission Issues**: Avoid Docker permission conflicts

## 🚀 Quick Start Commands

### Deploy Backend
```bash
# In Coolify dashboard
1. Create new project
2. Select docker-compose.backend.yml
3. Set environment variables
4. Deploy
```

### Deploy Frontend
```bash
# In Coolify dashboard
1. Create new project
2. Select docker-compose.frontend.yml
3. Set NEXT_PUBLIC_API_URL to backend domain
4. Deploy
```

This approach will solve the permission issues and give you much better control over your deployment! 