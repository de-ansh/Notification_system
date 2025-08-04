# Backend URL Update for Production

## 🎯 Updated Configuration

### Docker Compose Production
**File**: `docker-compose.prod.yml`

**Updated Frontend Environment**:
```yaml
frontend:
  environment:
    - NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001}
    - NODE_ENV=production
    - PORT=3000
```

### Backend CORS Configuration
**File**: `backend/src/server.ts`

**Updated CORS Origins**:
```typescript
origin: process.env.NODE_ENV === 'production' 
  ? [
      "https://notification-system-frontend-q6ii.vercel.app", 
      "http://localhost:3000", 
      "http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:3000",
      "http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:3000"
    ] 
  : "http://localhost:3000"
```

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

## 🧪 Testing the Configuration

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
- **Verify**: `NEXT_PUBLIC_API_URL` shows the correct URL
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
5. **Verify**: No calls to `localhost:5001`

## 📋 Deployment Steps

1. **Deploy updated code** to Coolify
2. **Set environment variables** as shown above
3. **Wait for services** to be healthy
4. **Test backend health** endpoint
5. **Check frontend debug panel**
6. **Test API functionality** (create users, posts)

## 🎯 Expected Result

After deployment:
- ✅ **Backend accessible** at the new URL
- ✅ **Frontend connects** to backend successfully
- ✅ **Socket.io connects** to the correct URL
- ✅ **CORS allows** frontend domain
- ✅ **API calls work** properly
- ✅ **Real-time notifications** function correctly

## 🔧 Troubleshooting

### Issue 1: CORS Errors
- **Check**: Backend CORS configuration includes frontend domain
- **Verify**: Both Socket.io and Express CORS are updated

### Issue 2: Network Errors
- **Check**: Backend is accessible at the new URL
- **Verify**: Environment variables are set correctly

### Issue 3: Environment Variables Not Working
- **Check**: Debug panel shows correct values
- **Verify**: Frontend service is redeployed after env var changes

The backend URL has been updated to use the production domain for proper communication between frontend and backend services! 