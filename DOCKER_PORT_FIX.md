# Docker Port Configuration Fix

## 🚨 Issue Fixed

**Problem**: Next.js frontend was running on port 5001 instead of port 3000, causing port conflicts with the backend.

## ✅ Solution Implemented

### 1. Created Startup Script (`frontend/start.sh`)

```bash
#!/bin/bash

# Set the port explicitly
export PORT=3000

# Start the Next.js standalone server
exec node .next/standalone/server.js
```

### 2. Updated Dockerfile.simple

**Changes made:**
- Added startup script copy: `COPY start.sh /app/start.sh`
- Made script executable: `RUN chmod +x /app/start.sh`
- Changed CMD to use startup script: `CMD ["/app/start.sh"]`

### 3. Updated Main Dockerfile

**Changes made:**
- Added startup script copy: `COPY start.sh /app/start.sh`
- Made script executable: `RUN chmod +x /app/start.sh`
- Changed CMD to use startup script: `CMD ["/app/start.sh"]`

## 🔧 How It Works

1. **Startup Script**: Explicitly sets `PORT=3000` environment variable
2. **Environment Variable**: Ensures Next.js uses port 3000
3. **Docker Configuration**: Both Dockerfiles now use the startup script
4. **Port Exposure**: `EXPOSE 3000` ensures Docker knows the correct port

## 📋 Files Modified

- ✅ `frontend/start.sh` - New startup script
- ✅ `frontend/Dockerfile.simple` - Updated to use startup script
- ✅ `frontend/Dockerfile` - Updated to use startup script

## 🚀 Expected Result

After deployment:
- ✅ Frontend runs on port 3000
- ✅ Backend runs on port 5001
- ✅ No port conflicts
- ✅ Both services accessible on their correct ports

## 🔍 Verification Commands

```bash
# Test backend (should work)
curl http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001/api/health

# Test frontend (should work after fix)
curl -I http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:3000
```

## 📝 Environment Variables Still Needed

**For Frontend Service in Coolify:**
```bash
NEXT_PUBLIC_API_URL=http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001
NODE_ENV=production
PORT=3000
```

## 🎯 Next Steps

1. **Deploy the updated code** to Coolify
2. **Set environment variables** as shown above
3. **Wait for services to be healthy**
4. **Test both frontend and backend ports**

The Docker port configuration should now ensure the frontend runs on port 3000 consistently! 