# Frontend Connection Fix

## 🚨 Issue: Frontend Not Loading Data

**Problem**: Frontend is accessible but showing no users or posts, indicating it can't connect to the backend API.

## 🔍 Root Cause Analysis

1. **API URL Configuration**: Frontend is trying to connect to `localhost:5001` instead of the backend service
2. **CORS Configuration**: Backend might not allow the frontend domain
3. **Network Communication**: Frontend and backend containers can't communicate

## ✅ Fixes Applied

### 1. Fixed Docker Compose Configuration

**Updated `docker-compose.prod.yml`**:

**Before:**
```yaml
frontend:
  environment:
    - NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-http://localhost:5001}
```

**After:**
```yaml
frontend:
  environment:
    - NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-http://backend:5001}
    - PORT=3000
```

### 2. Updated CORS Configuration

**Updated `backend/src/server.ts`** to allow the Coolify frontend domain:

```typescript
origin: process.env.NODE_ENV === 'production' 
  ? ["https://notification-system-frontend-q6ii.vercel.app", "http://localhost:3000", "http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:3000"] 
  : "http://localhost:3000"
```

## 🚀 How the Fix Works

### Docker Network Communication
- **Frontend container** can reach **backend container** using service name `backend`
- **Service name**: `http://backend:5001` (internal Docker network)
- **Not localhost**: `http://localhost:5001` (doesn't work between containers)

### CORS Allowlist
- **Vercel frontend**: `https://notification-system-frontend-q6ii.vercel.app`
- **Local development**: `http://localhost:3000`
- **Coolify frontend**: `http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:3000`

## 📋 Environment Variables

### For Frontend Service in Coolify:
```bash
NEXT_PUBLIC_API_URL=http://backend:5001
NODE_ENV=production
PORT=3000
```

### For Backend Service in Coolify:
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

## 🧪 Testing the Fix

### 1. Test Backend API
```bash
curl http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001/api/health
```

### 2. Test Users Endpoint
```bash
curl http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001/api/users
```

### 3. Test Frontend
1. Visit: `http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:3000`
2. Check browser console for errors
3. Try creating a user
4. Check if users appear in dropdown

## 🔧 Debugging Steps

### Check Browser Console
1. **Open Developer Tools** (F12)
2. **Go to Console tab**
3. **Look for errors** like:
   - CORS errors
   - Network errors
   - API connection failures

### Check Network Tab
1. **Go to Network tab**
2. **Refresh the page**
3. **Look for failed API calls**
4. **Check request URLs**

### Common Issues and Solutions

**Issue 1: CORS Error**
- **Solution**: Backend CORS is now configured for your domain

**Issue 2: Network Error**
- **Solution**: Frontend now uses `http://backend:5001` instead of `localhost`

**Issue 3: API Not Found**
- **Solution**: Ensure backend service is running and healthy

## 🎯 Expected Result

After the fix:
- ✅ **Frontend loads** with user dropdown
- ✅ **Create User button** works
- ✅ **Users appear** in dropdown after creation
- ✅ **Posts section** shows content
- ✅ **Notifications work** when user is selected

## 📞 Next Steps

1. **Deploy the updated code** to Coolify
2. **Set environment variables** as shown above
3. **Wait for services to be healthy**
4. **Test the frontend functionality**
5. **Check browser console** for any remaining errors

The frontend should now be able to connect to the backend and load users and posts! 