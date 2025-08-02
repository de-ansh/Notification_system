# Quick Fix for Coolify 404 Error

## Immediate Steps to Fix the 404 Error

### 1. Check Your Current Coolify Domain
Your domain appears to be: `sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io`

### 2. Set Environment Variables in Coolify

**Go to your Coolify dashboard and set these EXACT environment variables:**

#### For Frontend Service:
```bash
NEXT_PUBLIC_API_URL=https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io:5001
NODE_ENV=production
```

#### For Backend Service:
```bash
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production
```

### 3. Alternative API URL Options

If the above doesn't work, try these alternatives:

**Option 1: HTTP instead of HTTPS**
```bash
NEXT_PUBLIC_API_URL=http://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io:5001
```

**Option 2: Use IP address directly**
```bash
NEXT_PUBLIC_API_URL=http://82.25.105.179:5001
```

**Option 3: Remove port number (if Coolify handles routing)**
```bash
NEXT_PUBLIC_API_URL=https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io
```

### 4. Test Backend First

Before fixing the frontend, test if your backend is working:

```bash
# Test backend health
curl https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io:5001/api/health

# Test users endpoint
curl https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io:5001/api/users
```

### 5. Check Coolify Service Status

1. Go to your Coolify dashboard
2. Check if all services show as "Healthy"
3. Look at the logs for any errors
4. Make sure the backend service is running on port 5001

### 6. Redeploy After Changes

1. Update the environment variables
2. Redeploy the application
3. Wait for all services to be healthy
4. Test again

### 7. Debug Steps

If still not working:

1. **Check browser console** for JavaScript errors
2. **Check network tab** to see what URL the frontend is trying to access
3. **Verify the backend is accessible** using curl commands
4. **Check Coolify logs** for any deployment errors

### 8. Common Issues

- **CORS errors**: Backend should allow all origins
- **Port not exposed**: Make sure port 5001 is exposed in Coolify
- **Service not healthy**: Check if backend is actually running
- **Wrong domain**: Verify you're using the correct Coolify domain

### 9. Final Test

After making changes, test these URLs:

1. **Frontend**: `https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io`
2. **Backend Health**: `https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io:5001/api/health`
3. **Backend Users**: `https://sc4csk0scsgco0co8sk80coo.82.25.105.179.sslip.io:5001/api/users`

### 10. If Nothing Works

1. Check if Coolify is properly exposing port 5001
2. Verify the backend service is actually running
3. Look at Coolify's reverse proxy configuration
4. Consider using Coolify's built-in domain routing instead of ports 