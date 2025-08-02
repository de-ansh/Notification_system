# Coolify Deployment Troubleshooting

## Issue: 404 Not Found Error

### Problem
Getting a 404 error when accessing the deployed application on Coolify.

### Root Cause
The frontend is trying to access the backend API using incorrect URLs in the Coolify environment.

### Solution

#### 1. Set Correct Environment Variables in Coolify

**For the Frontend Service:**
```bash
NEXT_PUBLIC_API_URL=https://your-actual-coolify-domain.com:5001
```

**Replace `your-actual-coolify-domain.com` with your actual Coolify domain.**

#### 2. Alternative Solutions

**Option A: Use Subdomain**
```bash
NEXT_PUBLIC_API_URL=https://api.your-coolify-domain.com
```

**Option B: Use IP Address (if domain not configured)**
```bash
NEXT_PUBLIC_API_URL=http://your-server-ip:5001
```

#### 3. Verify Backend is Accessible

Test if the backend is working:
```bash
curl https://your-coolify-domain.com:5001/api/health
```

#### 4. Check Service Health

In Coolify dashboard:
1. Go to your project
2. Check if all services are "Healthy"
3. Look at the logs for any errors

#### 5. Common Issues and Fixes

**Issue: Frontend can't connect to backend**
- **Fix**: Set `NEXT_PUBLIC_API_URL` to the correct public backend URL

**Issue: CORS errors**
- **Fix**: Backend is configured to allow all origins in development

**Issue: Database connection errors**
- **Fix**: Check if `DATABASE_URL` is correct in environment variables

**Issue: Redis connection errors**
- **Fix**: Check if `REDIS_URL` is correct in environment variables

#### 6. Environment Variables Checklist

Make sure these are set in Coolify:

```bash
# Backend Environment Variables
DATABASE_URL=postgresql://postgres:password@postgres:5432/notification_system
REDIS_URL=redis://redis:6379
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=5001
NODE_ENV=production

# Frontend Environment Variables
NEXT_PUBLIC_API_URL=https://your-actual-coolify-domain.com:5001
NODE_ENV=production
```

#### 7. Testing Steps

1. **Test Backend Health:**
   ```bash
   curl https://your-domain:5001/api/health
   ```

2. **Test API Endpoints:**
   ```bash
   curl https://your-domain:5001/api/users
   curl https://your-domain:5001/api/posts
   ```

3. **Test Frontend:**
   - Visit your frontend URL
   - Check browser console for errors
   - Try creating a user or post

#### 8. Logs to Check

**Backend Logs:**
- Look for database connection errors
- Check for Redis connection issues
- Verify API endpoints are responding

**Frontend Logs:**
- Check for API connection errors
- Look for build issues
- Verify environment variables are loaded

#### 9. Redeployment Steps

1. Update environment variables in Coolify
2. Redeploy the application
3. Wait for all services to be healthy
4. Test the endpoints again

#### 10. Contact Support

If issues persist:
1. Check Coolify documentation
2. Review service logs thoroughly
3. Verify network connectivity
4. Ensure all ports are accessible 