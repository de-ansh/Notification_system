# Port Configuration Fix

## 🚨 Issue Identified

**Problem**: Next.js is running on port 5001 instead of port 3000
- Backend should be on port 5001 ✅
- Frontend should be on port 3000 ❌
- Currently both are trying to use port 5001

## 🔍 Root Cause

The frontend service is likely using the wrong port configuration or there's an environment variable conflict.

## ✅ Solution

### Step 1: Update Environment Variables in Coolify

**For Frontend Service:**
```bash
NEXT_PUBLIC_API_URL=http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001
NODE_ENV=production
PORT=3000
```

**For Backend Service:**
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

### Step 2: Verify Docker Compose Configuration

Make sure you're using `docker-compose.prod.yml` with correct port mappings:

```yaml
backend:
  ports:
    - "5001:5001"  # Backend on port 5001

frontend:
  ports:
    - "3000:3000"  # Frontend on port 3000
```

### Step 3: Check Dockerfile Configuration

**Frontend should use `Dockerfile.simple`** which has:
```dockerfile
ENV PORT 3000
EXPOSE 3000
CMD ["node", ".next/standalone/server.js"]
```

### Step 4: Redeploy and Test

1. **Update environment variables** in Coolify
2. **Redeploy the application**
3. **Wait for all services to be healthy**

### Step 5: Verify Port Configuration

**Test Backend (should work):**
```bash
curl http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001/api/health
```

**Test Frontend (should work after fix):**
```bash
curl -I http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:3000
```

## 🔧 Alternative Solutions

### Option 1: Use Reverse Proxy
If Coolify is routing everything through port 80, you might need to configure a reverse proxy to route:
- `/api/*` → Backend (port 5001)
- `/*` → Frontend (port 3000)

### Option 2: Change Frontend Port
If you can't fix the port conflict, you could change the frontend to use a different port:
```bash
PORT=3001
```

### Option 3: Use Subdomains
Configure Coolify to use subdomains:
- `api.your-domain.com` → Backend
- `app.your-domain.com` → Frontend

## 🚀 Expected Result

After the fix:
- ✅ Backend accessible on port 5001
- ✅ Frontend accessible on port 3000
- ✅ No port conflicts
- ✅ Both services running independently

## 📋 Checklist

- [ ] Frontend environment has `PORT=3000`
- [ ] Backend environment has `PORT=5001`
- [ ] Using correct Docker Compose file
- [ ] Using `Dockerfile.simple` for frontend
- [ ] Port mappings are correct
- [ ] No environment variable conflicts
- [ ] Both services are healthy in Coolify 