# Coolify Environment Variables Setup

## 🚨 CRITICAL: Fix the 404 Error

The 404 error is happening because the frontend is trying to connect to `localhost:5001` instead of your Coolify backend URL.

## ✅ Solution: Set These Environment Variables in Coolify

### For Frontend Service:
```bash
NEXT_PUBLIC_API_URL=http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001
NODE_ENV=production
PORT=3000
```

### For Backend Service:
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

## 🔧 Alternative API URLs (if the above doesn't work)

Try these alternatives in order:

### Option 1: Use HTTPS instead of HTTP
```bash
NEXT_PUBLIC_API_URL=https://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001
```

### Option 2: Remove port number (if Coolify handles routing)
```bash
NEXT_PUBLIC_API_URL=http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io
```

### Option 3: Use IP address directly
```bash
NEXT_PUBLIC_API_URL=http://82.25.105.179:5001
```

## 📋 Steps to Apply the Fix

1. **Go to your Coolify dashboard**
2. **Select your project**
3. **Go to Environment Variables section**
4. **Add/Update the variables above**
5. **Redeploy the application**
6. **Wait for all services to be healthy**

## 🧪 Test the Fix

### Test Backend First:
```bash
curl http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io:5001/api/health
```

Expected response:
```json
{"message":"Notification System API is running"}
```

### Test Frontend:
1. Visit: `http://cco0c0gs4808cwogwcgw04kw.82.25.105.179.sslip.io`
2. Check browser console for errors
3. Try creating a user or post

## 🔍 What Was Fixed

1. **Frontend Code**: Now uses `NEXT_PUBLIC_API_URL` environment variable instead of hardcoded localhost
2. **Socket.io**: Now connects to the correct backend URL
3. **API Calls**: Now use the correct backend URL for all requests

## ⚠️ Important Notes

- The frontend code has been updated to use environment variables
- You MUST set the `NEXT_PUBLIC_API_URL` in Coolify
- The backend CORS is already configured to allow your Vercel frontend
- Make sure to redeploy after setting environment variables 