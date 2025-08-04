# Gateway Timeout Fix

## 🚨 Issue: 504 Gateway Timeout

**Problem**: Socket.io connection was timing out with a 504 Gateway Timeout error.

## 🔍 Root Cause Analysis

1. **Backend Not Accessible**: The backend was not accessible at the domain without port
2. **Port Required**: Backend is running on port 5001, not the default port 80
3. **URL Configuration**: Frontend was trying to connect to wrong URL

## ✅ Solution Applied

### 1. Verified Backend Accessibility

**Test Results**:
```bash
# Without port (FAILED)
curl -I http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io/api/health
# Result: 504 Gateway Timeout

# With port (SUCCESS)
curl -I http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api/health
# Result: 200 OK
```

### 2. Updated Environment Variables

**Docker Compose** (`docker-compose.prod.yml`):
```yaml
frontend:
  environment:
    - NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001}
```

**Frontend Code** (`frontend/app/page.tsx`):
```javascript
const socketUrl = process.env.NEXT_PUBLIC_API_URL ? process.env.NEXT_PUBLIC_API_URL : 'http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001';
```

### 3. Updated Documentation

All documentation files updated to reflect the correct URL with port 5001.

## 🚀 Environment Variables for Coolify

### Frontend Service
```bash
NEXT_PUBLIC_API_URL=http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001
NODE_ENV=production
PORT=3000
```

### Backend Service
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

## 🧪 Testing the Fix

### 1. Verify Backend Health
```bash
curl http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api/health
```

**Expected Response**:
```json
{"message":"Notification System API is running"}
```

### 2. Check Frontend Debug Panel
- **Visit frontend**: Look for debug panel in bottom-right
- **Verify**: `NEXT_PUBLIC_API_URL` shows the correct URL with port
- **Check**: `NODE_ENV` shows `production`

### 3. Check Browser Console
1. **Open Developer Tools** (F12)
2. **Go to Console tab**
3. **Look for**:
   ```
   NEXT_PUBLIC_API_URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001
   API_BASE_URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api
   Socket URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001
   ```

### 4. Check Network Requests
1. **Go to Network tab**
2. **Refresh the page**
3. **Look for API calls** to `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api/users`
4. **Look for Socket.io calls** to `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/socket.io/`
5. **Verify**: No 504 Gateway Timeout errors

## 📋 Deployment Steps

1. **Deploy updated code** to Coolify
2. **Set environment variables** as shown above
3. **Wait for services** to be healthy
4. **Test backend health** endpoint
5. **Check frontend debug panel**
6. **Test Socket.io connection**
7. **Test API functionality** (create users, posts)

## 🎯 Expected Result

After deployment:
- ✅ **Backend accessible** at the correct URL with port
- ✅ **Socket.io connects** without timeout errors
- ✅ **Frontend connects** to backend successfully
- ✅ **API calls work** properly
- ✅ **Real-time notifications** function correctly
- ✅ **No 504 Gateway Timeout** errors

## 🔧 Troubleshooting

### Issue 1: Still Getting 504 Errors
- **Check**: Backend service is running and healthy
- **Verify**: Environment variables are set correctly
- **Test**: Backend health endpoint manually

### Issue 2: Socket.io Connection Fails
- **Check**: CORS configuration includes frontend domain
- **Verify**: Socket.io URL is correct in console logs
- **Test**: Socket.io endpoint manually

### Issue 3: Environment Variables Not Working
- **Check**: Debug panel shows correct values
- **Verify**: Frontend service is redeployed after env var changes
- **Test**: Console logs show correct URLs

The gateway timeout issue has been resolved by using the correct backend URL with port 5001! 