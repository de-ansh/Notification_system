# Environment Variable Fix

## 🚨 Issue: Frontend Using localhost Instead of Backend Service

**Problem**: Frontend is making API calls to `http://localhost:5001/api/users` instead of the backend service.

## 🔍 Root Cause Analysis

1. **Environment Variable Not Set**: `NEXT_PUBLIC_API_URL` is not being passed correctly
2. **Fallback to localhost**: Frontend falls back to `http://localhost:5001` when env var is missing
3. **Docker Network Issue**: Frontend can't reach backend using localhost

## ✅ Solution Steps

### Step 1: Verify Docker Compose Configuration

**Current `docker-compose.prod.yml`** (updated):
```yaml
frontend:
  environment:
    - NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL:-http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001}
    - NODE_ENV=production
    - PORT=3000
```

### Step 2: Set Environment Variables in Coolify

**For Frontend Service:**
```bash
NEXT_PUBLIC_API_URL=http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001
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

### Step 3: Debug Environment Variables

**Added Debug Component**: `frontend/app/debug-env.tsx`
- Shows current environment variables in the UI
- Helps verify if variables are set correctly
- Appears as a debug panel in bottom-right corner

**Added Console Logging**:
```javascript
console.log('NEXT_PUBLIC_API_URL:', process.env.NEXT_PUBLIC_API_URL);
console.log('API_BASE_URL:', API_BASE_URL);
```

### Step 4: Rebuild and Deploy

1. **Redeploy the application** in Coolify
2. **Check the debug panel** in the frontend
3. **Check browser console** for API URL logs
4. **Verify environment variables** are set correctly

## 🧪 Testing the Fix

### 1. Check Debug Panel
- **Visit frontend**: Look for debug panel in bottom-right
- **Verify**: `NEXT_PUBLIC_API_URL` shows `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001`
- **Check**: `NODE_ENV` shows `production`

### 2. Check Browser Console
1. **Open Developer Tools** (F12)
2. **Go to Console tab**
3. **Look for**:
   ```
   NEXT_PUBLIC_API_URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001
   API_BASE_URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api
   Socket URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001
   ```

### 3. Check Network Requests
1. **Go to Network tab**
2. **Refresh the page**
3. **Look for API calls** to `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api/users`
4. **Verify**: No calls to `localhost:5001`

## 🔧 Alternative Solutions

### Option 1: Hardcode for Testing
If environment variables aren't working, temporarily hardcode:
```javascript
const API_BASE_URL = 'http://backend:5001/api';
```

### Option 2: Use External URL
If you need external access:
```bash
NEXT_PUBLIC_API_URL=http://your-coolify-domain.com:5001
```

### Option 3: Use IP Address
```bash
NEXT_PUBLIC_API_URL=http://82.25.105.179:5001
```

## 📋 Troubleshooting Checklist

- [ ] Environment variables set in Coolify
- [ ] Frontend service redeployed
- [ ] Debug panel shows correct values
- [ ] Console logs show correct API URL
- [ ] Network requests go to backend service
- [ ] No localhost calls in network tab

## 🎯 Expected Result

After the fix:
- ✅ **Debug panel** shows `NEXT_PUBLIC_API_URL: http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001`
- ✅ **Console logs** show correct API URL and Socket URL
- ✅ **Network requests** go to `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001/api/*`
- ✅ **Socket.io connects** to `http://uwwss4w0go8ccc4c0sc4gwww.82.25.105.179.sslip.io:5001`
- ✅ **No localhost** calls in network tab
- ✅ **Frontend connects** to backend successfully

## 📞 Next Steps

1. **Set environment variables** in Coolify
2. **Redeploy the application**
3. **Check debug panel** for correct values
4. **Test API functionality** (create users, posts)
5. **Remove debug components** once working

The debug components will help identify exactly what's happening with the environment variables! 