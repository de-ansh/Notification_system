# Coolify Troubleshooting - Latest Issue

## 🚨 Current Situation

- ✅ **Backend is working**: `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io/api/health` returns 200
- ❌ **Frontend is not accessible**: `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io` returns 404
- ❌ **Frontend port 3000 is not accessible**: Connection timeout

## 🔍 Root Cause Analysis

The issue is that **only the backend is running and accessible**. The frontend service is either:
1. Not running
2. Not properly exposed
3. Not configured correctly in Coolify

## ✅ Solution Steps

### Step 1: Check Coolify Service Status

1. **Go to your Coolify dashboard**
2. **Check if all services are "Healthy"**
3. **Look for any failed services**
4. **Check the logs for frontend service**

### Step 2: Verify Environment Variables

**For Frontend Service:**
```bash
NEXT_PUBLIC_API_URL=http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io
NODE_ENV=production
```

**For Backend Service:**
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

### Step 3: Check Docker Compose Configuration

Make sure you're using `docker-compose.prod.yml` in Coolify with these services:
- `postgres` (Database)
- `redis` (Cache)
- `backend` (API Server)
- `frontend` (Next.js App)

### Step 4: Redeploy the Application

1. **Update environment variables** in Coolify
2. **Redeploy the entire application**
3. **Wait for all services to be healthy**
4. **Check logs for any errors**

### Step 5: Test the Deployment

**Test Backend (should work):**
```bash
curl http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io/api/health
```

**Test Frontend (should work after fix):**
```bash
curl -I http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io
```

## 🔧 Common Issues and Fixes

### Issue 1: Frontend Service Not Starting
- **Check logs**: Look for Docker build errors
- **Check Dockerfile**: Make sure `Dockerfile.simple` is being used
- **Check standalone output**: Verify the standalone server fix is applied

### Issue 2: Port Configuration
- **Frontend should be on port 3000**
- **Backend should be on port 5001**
- **Check if ports are properly exposed**

### Issue 3: Environment Variables
- **Make sure `NEXT_PUBLIC_API_URL` is set correctly**
- **Don't include `/api` in the URL** (frontend code adds it)
- **Use HTTP, not HTTPS** (based on current setup)

### Issue 4: Service Dependencies
- **Frontend depends on backend**
- **Backend depends on database and Redis**
- **Check service startup order**

## 🚀 Quick Fix Checklist

- [ ] All services are "Healthy" in Coolify
- [ ] Environment variables are set correctly
- [ ] Using `docker-compose.prod.yml`
- [ ] Frontend service is running
- [ ] Port 3000 is accessible
- [ ] No Docker build errors
- [ ] Standalone server fix is applied

## 📞 Next Steps

1. **Check Coolify dashboard** for service status
2. **Update environment variables** with the new domain
3. **Redeploy the application**
4. **Test both backend and frontend**
5. **Check browser console** for any JavaScript errors

## 🔍 Debug Commands

```bash
# Test backend
curl http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io/api/health

# Test frontend
curl -I http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io

# Test frontend port
curl -I http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:3000
``` 